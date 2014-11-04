# ImageResizer

A ReSRC.it wrapper gem. It allows a fluent interface to resrc.it services. You can find the official ReSRC.it documentation here:

[http://www.resrc.it/docs](http://www.resrc.it/docs)

## Basic usage

    ImageResizer.process('foo.jpg').resize(width: 100, height: 90).quality(80).to_s
    # => "//images-resrc.staticlp.com/S=W100,H90/O=80/foo.jpg"

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
