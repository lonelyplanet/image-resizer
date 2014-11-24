require 'spec_helper'

module ImageResizer
  describe Image do
    subject { described_class.new('foo.jpg') }

    describe '#operations' do
      it 'delegates the operations methods to a local format object' do
        expect(subject.format).to be_kind_of(Format)
      end

      it 'populates the operations array' do
        expect(subject.optimize(quality: 80).operations.size).to eq(1)
      end
    end

    describe '#to_url' do
      it 'returns the original filename if no operations are defined' do
        expect(subject.to_url).to eq('foo.jpg')
      end

      it 'returns the complete URL with service URL and encoded operations' do
        expect(subject.optimize(quality: 80).to_url).to eq(
          '//images-resrc.staticlp.com/O=80/foo.jpg'
        )
      end

      it 'prevents double ReSRC.it URLs' do
        item = described_class.new('http://resrc.it/foobar/http://foo.jpg')
        output = item.optimize(quality: 50).to_url
        expect(output).to eq('//images-resrc.staticlp.com/O=50/http://foo.jpg')
      end
    end

    describe '#safe_full_url' do
      {
        'http://example.com/foobar.jpg' => 'http://example.com/foobar.jpg',
        '/foobar.jpg'                   => '/foobar.jpg',
        '//foobar.jpg'                  => '//foobar.jpg',
        'http://foo/http//foobar.jpg'   => '//foobar.jpg',
        '//foo/http://foobar.jpg'       => '//foobar.jpg',
        '//foo/http//foobar.jpg'        => '//foobar.jpg',
        '//foo/http://foobar.jpg'       => 'http://foobar.jpg'
      }.each_pair do |input, output|
        specify do
          expect(described_class.new(input).full_url).to eq(output)
        end
      end

      context 'with a media domain set' do
        before { ImageResizer.media_domain = '//lp.com' }
        after  { ImageResizer.media_domain = nil }

        {
          'http://example.com/foobar.jpg' => 'http://example.com/foobar.jpg',
          '/foobar.jpg'                   => '//lp.com/foobar.jpg',
          '//foobar.jpg'                  => '//foobar.jpg',
          'http://foo/http//foobar.jpg'   => '//foobar.jpg',
          '//foo/http://foobar.jpg'       => '//foobar.jpg',
          '//foo/http//foobar.jpg'        => '//foobar.jpg',
          '//foo/http://foobar.jpg'       => 'http://foobar.jpg'
        }.each_pair do |input, output|
          specify do
            expect(described_class.new(input).full_url).to eq(output)
          end
        end
      end
    end
  end
end
