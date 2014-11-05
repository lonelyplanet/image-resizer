module ImageResizer
  class Image
    SERVICE = ENV['IMAGE_RESIZE_SERVICE'] || '//images-resrc.staticlp.com/'

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
    )

    def_delegators :format, *FORMAT_METHODS

    def initialize(url, format: nil)
      @url = url
      @format = format
    end

    def format
      @format ||= Format.new(self)
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
        "#{service}/#{format}/#{url}"
      else
        url
      end
    end
    alias_method :to_s, :to_url
  end
end
