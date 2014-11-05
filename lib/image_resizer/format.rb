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

    def operations
      @operations ||= []
    end

    # Outputs the operations chain in Resrc.it's format
    #
    def to_s
      operations.map do |o|
        operation_to_s(o)
      end.join '/'
    end

    def needs_operations?
      apply_defaults!
      operations.any?
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

    def apply_defaults!
      if (quality = ImageResizer.default_quality) && !has_operation?(:optimize)
        optimize(quality: quality)
      end
    end

    def has_operation?(operation_key)
      operations.any?{|o| o[:operation] == operation_key}
    end
  end
end
