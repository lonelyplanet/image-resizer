require 'spec_helper'

module ImageResizer
  describe Image do
    subject { described_class.new('foo.jpg') }

    describe '#operations' do
      it 'delegates the operations methods to a local format object' do
        expect(subject.format).to be_kind_of(Format)
      end

      it 'populates the operations array' do
        expect(subject.quality(80).operations.size).to eq(1)
      end
    end

    describe '#to_s' do
      it 'returns the original filename if no operations are defined' do
        expect(subject.to_s).to eq('foo.jpg')
      end

      it 'returns the complete URL with service URL and encoded operations' do
        expect(subject.quality(80).to_s).to eq('//images-resrc.staticlp.com/O=80/foo.jpg')
      end
    end
  end
end
