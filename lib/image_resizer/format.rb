module ImageResizer
  class Format
    # Optional attributes. If set, the format will be able to validate the crop
    # parameters
    #
    attr_accessor :original_image_width, :original_image_height

    # The owner parameter sets the object returned by the operations methods.
    # This allows ImageResizer::Image a fluent interface
    #
    def initialize(owner = nil)
      @owner ||= owner || self
    end

    # Resizes an image. Named parameters:
    # width, height, upscale
    #
    def resize(width: nil, height: nil, upscale: false)
      operations << {operation: :resize, width: width, height: height,
        upscale: upscale}
      @owner
    end

    # Optimization options.
    #
    # - quality: 1-100
    # - baseline: boolean
    # - progressive: boolean
    #
    def optimize(quality: 85, baseline: false, progressive: false)
      operations << {operation: :optimize, quality: quality,
                                           baseline: baseline,
                                           progressive: progressive}
      @owner
    end

    # Sets the image aspect ratio. Parameter must be in WxH format
    #
    def aspect_ratio(ratio)
      operations << {operation: :aspect_ratio, value: ratio}
      @owner
    end

    # Regular crop. Make sure the values don't exceed the image size
    #
    def crop(width: 0, height: 0, x_offset: 0, y_offset: 0)
      operations << {
        operation: :crop, width: width.to_i, height: height.to_i,
          x_offset: x_offset.to_i, y_offset: y_offset.to_i}
      @owner
    end

    # Enables a square crop
    #
    def square_crop
      operations << {operation: :square_crop}
      @owner
    end

    # Shortcut method to resize using a "1024x768" kind of string
    #
    def resize_wxh(string)
      width, height = string.split('x')
      resize(width: width.to_i, height: height.to_i)
    end

    # Shortcut method for JCrop-based crops
    #
    #     WIDTH:HEIGHT;XOFFSET,YOFFSET
    #
    def crop_from_jcrop(string)
      width, height, x_offset, y_offset = string.split(/[:;,]/).map(&:to_i)
      crop(width: width, height: height, x_offset: x_offset, y_offset: y_offset)
    end

    # Outputs the operations chain in Resrc.it's format
    #
    def to_s
      all_operations.map do |o|
        operation_to_s(o)
      end.join '/'
    end

    def operations
      @operations ||= []
    end

    def default_operations
      ops = []
      if quality = ImageResizer.default_quality
        ops << {operation: :optimize, quality: quality}
      end
      ops
    end

    # User-defined operations plus defaults (unless the user-defined) overrides
    # the default
    #
    def all_operations
      operations + default_operations.reject do |op|
        has_operation?(op[:operation])
      end
    end

    # Does the image require any processing?
    #
    def needs_operations?
      all_operations.any?
    end

    # Ensures the operations are valid. Won't work if the original image width
    # and height values are unknown though.
    #
    def valid?
      return true unless original_image_width && original_image_height
      if op = find_operation(:crop)
        return false if op[:width].zero? || op[:height].zero?
        return false if op[:width]  + op[:x_offset] > original_image_width
        return false if op[:height] + op[:y_offset] > original_image_height
      end
      true
    end

    # Tries to fix the crop values. Requires original image width and height.
    # Returns the object so to allow method chaining.
    #
    def fix_crop!
      return @owner unless original_image_width && original_image_height
      return @owner unless crop = find_operation(:crop)
      safe_w, safe_x = safe_bounds(crop[:width],  crop[:x_offset], original_image_width)
      safe_h, safe_y = safe_bounds(crop[:height], crop[:y_offset], original_image_height)
      crop.merge!(
        width: safe_w, height: safe_h, x_offset: safe_x, y_offset: safe_y
      )
      @owner
    end

    # Deep copy
    #
    def clone
      Marshal.load(Marshal.dump(self))
    end

    # Shortcut initializer:
    #
    #   ImageResizer::Format.from_hash(resize: {width: 100},
    #                                  optimize: {quality: 50})
    #
    def self.from_hash(hash)
      new.tap do |format|
        hash.each_pair do |op, params|
          format.operations << {operation: op}.merge(params)
        end
      end
    end

    private

    def operation_to_s(op)
      case op[:operation]
      when :optimize
        out = "O=#{op[:quality]}"
        out += ",P" if op[:progressive]
        out += ",B" if op[:baseline]
        out
      when :aspect_ratio
        "C=AR#{op[:value]}"
      when :square_crop
        "C=SQ"
      when :resize
        tokens = []
        tokens << "W#{op[:width]}"  if op[:width]
        tokens << "H#{op[:height]}" if op[:height]
        tokens << "U" if op[:upscale]
        "S=#{tokens.join(',')}"
      when :crop
        "C=W#{op[:width]},H#{op[:height]},X#{op[:x_offset]},Y#{op[:y_offset]}"
      end
    end

    def has_operation?(operation_key)
      find_operation(operation_key)
    end

    def find_operation(operation_key)
      operations.find{|op| op[:operation] == operation_key}
    end

    # Returns the safe crop size and offset as a two-item array. If value+offset
    # exceeds the image size then shrink the value and keep the offset.
    #
    def safe_bounds(value, offset, max)
      end_offset = [(value + offset), max].min
      beg_offset = [offset, 0].max
      [(end_offset - beg_offset), beg_offset]
    end
  end
end
