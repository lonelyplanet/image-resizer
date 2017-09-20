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
        'https://images-resrc.staticlp.com/O=25/foo.jpg'
        )
    end
  end

  describe '.default_quality' do
    subject { ImageResizer.process('foo.jpg') }

    it 'sets the value as module variable' do
      ImageResizer.default_quality = 80
      expect(ImageResizer.default_quality).to eq(80)
    end

    it 'ignores the value when not set' do
      expect(subject.optimize(quality: 25).to_s).to eq(
        'https://images-resrc.staticlp.com/O=25/foo.jpg'
        )
    end

    it 'applies the value when set' do
      ImageResizer.default_quality = 80
      expect(subject.to_s).to eq(
        'https://images-resrc.staticlp.com/O=80/foo.jpg'
        )
    end

    it 'overrides the value when explicitly set' do
      ImageResizer.default_quality = 80
      expect(subject.optimize(quality: 25).to_s).to eq(
        'https://images-resrc.staticlp.com/O=25/foo.jpg'
        )
    end
  end

  describe '.media_domain' do
    it 'sets the value as module variable' do
      ImageResizer.media_domain = '//lp.com'
      expect(ImageResizer.media_domain).to eq('//lp.com')
    end
  end
end
