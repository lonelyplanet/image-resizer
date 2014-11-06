# ImageResizer

A ReSRC.it wrapper gem. It allows a fluent interface to resrc.it services. You can find the official ReSRC.it documentation here:

[http://www.resrc.it/docs](http://www.resrc.it/docs)

## Basic usage

    ImageResizer.process('foo.jpg').resize(width: 100, height: 90).optimize(quality: 80).to_s
    # => "//images-resrc.staticlp.com/S=W100,H90/O=80/foo.jpg"

## Default parameters

You can have an initializer with some values:

    # The ReSRC.it URL
    ImageResizer.media_service = '//resrc.it'

    # Domain to use on images lacking a full URI
    ImageResizer.media_domain = '//media.lonelyplanet.com'

    # Default optimization value
    ImageResizer.default_quality = 80

if you want to. The quality setting will be applied to all images unless overridden on individual items.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'image-resizer'
```

And then execute:

    $ bundle

## Contributing

1. Fork it ( https://github.com/lonelyplanet/image-resizer/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
