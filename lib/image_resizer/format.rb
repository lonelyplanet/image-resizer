module ImageResizer
  class Format
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
        operation: :crop, width: width, height: height,
          x_offset: x_offset, y_offset: y_offset}
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
      resize(width: width, height: height)
    end

    # Shortcut method for JCrop-based crops
    #
    #     WIDTH:HEIGHT;XOFFSET,YOFFSET
    #
    def crop_from_jcrop(string)
      width, height, x_offset, y_offset = string.split(/[:;,]/)
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

    # Deep copy
    #
    def clone
      Marshal.load(Marshal.dump(self))
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
      operations.any?{|o| o[:operation] == operation_key}
    end
  end
end
