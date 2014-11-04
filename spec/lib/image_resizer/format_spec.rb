require 'spec_helper'

module ImageResizer
  describe Format do
    describe 'operations' do
      let(:output) { subject.to_s }

      describe '#quality' do
        subject { described_class.new.quality(80) }
        specify { expect(output).to eq 'O=80'}
      end

      describe '#aspect_ratio' do
        subject { described_class.new.aspect_ratio('16x9') }
        specify { expect(output).to eq 'C=AR16x9' }
      end

      describe '#square_crop' do
        subject { described_class.new.square_crop }
        specify { expect(output).to eq 'C=SQ' }
      end

      describe '#resize' do
        subject { described_class.new.resize(width: 80, height: 70,
          upscale: true) }
        specify { expect(output).to eq 'S=W80,H70,U' }
      end

      describe '#crop' do
        subject { described_class.new.crop(width: 80, height: 70,
          x_offset: 10, y_offset: 20) }
        specify { expect(output).to eq 'C=W80,H70,X10,Y20' }
      end
    end
  end
end