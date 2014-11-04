require 'spec_helper'

describe ImageResizer do
  describe '.process' do
    it 'returns an Image object' do
      expect(ImageResizer.process('foo.jpg')).to be_kind_of(ImageResizer::Image)
    end
  end
end
