require 'forwardable'

module ImageResizer
  # Shortcut method
  #
  # ImageResizer.process('foo.jpg').quality(80)
  #
  def self.process(img, format: nil)
    Image.new(img, format: format)
  end

  # Returns the final resized URL. Chaining is not possible.
  #
  def self.url_for(img, format = nil)
    process(img, format: format).to_s
  end

  #
  # Main settings
  #

  # Default domain, used when the image URL doesn't include the host
  #
  def self.media_domain=(domain)
    @media_domain = domain
  end

  # Default image domain
  #
  def self.media_domain
    @media_domain
  end

  # Media service URL
  #
  def self.media_service=(service)
    @media_service = service
  end

  # Default image service
  #
  def self.media_service
    @media_service || 'https://images-resrc.staticlp.com'
  end

  # Sets quality value
  #
  def self.default_quality=(value)
    @default_quality = value
  end

  # Gets quality value
  #
  def self.default_quality
    @default_quality
  end
end

require 'image_resizer/version'
require 'image_resizer/image'
require 'image_resizer/format'
