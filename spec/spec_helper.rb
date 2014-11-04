$LOAD_PATH.unshift File.expand_path('lib')
ENV['test'] = 'true'

require 'rspec'
require 'image_resizer'

RSpec.configure do |config|
end
