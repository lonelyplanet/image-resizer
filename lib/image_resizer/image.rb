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
      quality
      aspect_ratio
      crop
      square_crop
      operations
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

    def to_s
      if operations.size == 0
        url
      else
        "#{service}/#{format}/#{url}"
      end
    end
  end
end
