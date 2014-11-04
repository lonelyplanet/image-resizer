require 'spec_helper'

describe ImageResizer do
  describe '.process' do
    it 'returns an Image object' do
      expect(ImageResizer.process('foo.jpg')).to be_kind_of(ImageResizer::Image)
    end
  end

  describe '.url_for' do
    it 'combines all operations in a single call' do
      format = ImageResizer::Format.new.optimize(quality: 25)
      expect(ImageResizer.url_for('foo.jpg', format)).to eq(
        '//images-resrc.staticlp.com/O=25/foo.jpg'
        )
    end
  end
end
