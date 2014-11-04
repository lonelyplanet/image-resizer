require 'forwardable'

module ImageResizer
  # Shortcut method
  #
  # ImageResizer.process('foo.jpg').quality(80)
  #
  def self.process(img)
    Image.new(img)
  end
end

require 'image_resizer/version'
require 'image_resizer/image'
require 'image_resizer/format'
