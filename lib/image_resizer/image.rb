module ImageResizer
  class Image
    extend Forwardable

    attr_accessor :url

    # Format methods that allow a fluent interface. Example:
    #
    # Image.new('foo.jpg').quality(80).square_crop
    #
    FORMAT_METHODS = %i(
      resize
      aspect_ratio
      crop
      square_crop
      operations
      optimize
      needs_operations?
      resize_wxh
      crop_from_jcrop
    )

    def_delegators :format, *FORMAT_METHODS

    def initialize(url, format: nil)
      @url = url
      @format = format
    end

    def format
      @format ||= Format.new(self)
    end

    # ReSRC.it expects a full URL
    #
    def full_url
      @full_url ||= if full_url?
        url
      else
        (domain = ImageResizer.media_domain) ? "#{domain}/#{url}" : url
      end
    end

    # Ensures there are no trailing slashes
    #
    def service
      @service ||= SERVICE.end_with?('/') ? SERVICE.chop : SERVICE
    end

    # Main output method. Aliases to +to_s+ to simplify tag helpers
    #
    def to_url
      if needs_operations?
        "#{ImageResizer.media_service}/#{format}/#{full_url}".gsub('///', '//')
      else
        full_url
      end
    end
    alias_method :to_s, :to_url

    private

    def full_url?
      url =~ %r{^http(s)?://} || url =~ %r{^//}
    end
  end
end
