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
  def self.url_for(img, format)
    process(img, format: format).to_s
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
