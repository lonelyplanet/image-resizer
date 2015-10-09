require 'spec_helper'

module ImageResizer
  describe Format do
    let(:output) { subject.to_s }

    describe 'operations' do
      let(:format) { described_class.new }

      describe '#optimize' do
        subject { format.optimize(quality: 80) }
        specify { expect(output).to eq 'O=80'}
      end

      describe '#effects' do
        describe 'sharpen with default value' do
          subject { format.effects(sharpen: 10) }
          specify { expect(output).to eq 'E=S'}
        end

        describe 'sharpen with custom value' do
          subject { format.effects(sharpen: 20) }
          specify { expect(output).to eq 'E=S20'}
        end

        describe 'greyscale only' do
          subject { format.effects(greyscale: true) }
          specify { expect(output).to eq 'E=G'}
        end

        describe 'greyscale and sharpen' do
          subject { format.effects(sharpen: 20, greyscale: true) }
          specify { expect(output).to eq 'E=S20,G'}
        end
      end

      describe '#aspect_ratio' do
        subject { format.aspect_ratio('16x9') }
        specify { expect(output).to eq 'C=AR16x9' }
      end

      describe '#square_crop' do
        subject { format.square_crop }
        specify { expect(output).to eq 'C=SQ' }
      end

      describe '#resize' do
        subject { format.resize(width: 80, height: 70,
          upscale: true) }
        specify { expect(output).to eq 'S=W80,H70,U' }
      end

      describe '#crop' do
        context 'with normal crop' do
          subject { format.crop(width: 80, height: 70,
            x_offset: 10, y_offset: 20) }
          specify { expect(output).to eq 'C=W80,H70,X10,Y20' }
        end

        context 'with a relative crop offset' do
          subject { format.crop(width: 80, height: 70,
            x_offset: 'OF10', y_offset: 'OF20') }
          specify { expect(output).to eq 'C=W80,H70,XOF10,YOF20' }
        end
      end

      describe '#resize_wxh' do
        subject { format.resize_wxh('1024x768') }
        specify { expect(output).to eq 'S=W1024,H768' }
      end

      describe '#crop_from_jcrop' do
        subject { format.crop_from_jcrop('10:20;30,40') }
        it 'parses the custom string correctly' do
          expect(output).to eq 'C=W10,H20,X30,Y40'
        end
      end
    end

    describe '.from_hash' do
      specify do
        expect(
          described_class.from_hash(optimize: {quality: 50}).to_s
        ).to eq('O=50')
      end

      specify do
        expect(
          described_class.from_hash(resize: {width: 100}).to_s
        ).to eq('S=W100')
      end

      specify do
        expect(described_class.from_hash(resize: {width: 100},
                                         optimize: {quality: 90}).to_s
        ).to eq('S=W100/O=90')
      end
    end

    describe '#valid?' do
      context 'a normal format' do
        it { is_expected.to be_valid }
      end

      context 'a regular crop' do
        subject { described_class.new.crop(width: 10, height: 20) }

        it 'is considered valid if we ignore the original image size' do
          expect(subject).to be_valid
        end

        context 'with original image size available' do
          subject do
            described_class.new.tap do |f|
              f.original_image_width  = 400
              f.original_image_height = 300
            end
          end

          it 'honours good crop values' do
            expect(subject.crop(width: 100, height: 100)).to be_valid
          end

          it 'detects bad crop values' do
            expect(subject.crop(width: 500, height: 400)).to_not be_valid
            expect(subject.crop(width: 0, height: 400)).to_not be_valid
          end
        end
      end

      context 'a zero-dimension crop' do
        specify do
          expect(subject.crop(width: 0, height: 400)).to_not be_valid
        end
      end
    end

    describe '#fix_crop!' do
      subject do
        described_class.new.tap do |f|
          f.original_image_width  = 400
          f.original_image_height = 300
        end
      end

      it "doesn't change healthy crops" do
        expect(
          subject.crop(width: 100, height: 200).fix_crop!.to_s
          ).to eq('C=W100,H200,X0,Y0')
      end

      it 'fixes bad crops' do
        expect(
          subject.crop(width: 500, height: 900).fix_crop!.to_s
          ).to eq('C=W400,H300,X0,Y0')
      end

      it 'fixes bad crops' do
        expect(
          subject.crop(width: 300, height: 200, x_offset: 150, y_offset: 200).fix_crop!.to_s
          ).to eq('C=W250,H100,X150,Y200')
      end
    end

  end # describe Format
end # ImageResizer
