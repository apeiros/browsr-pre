$LOAD_PATH.unshift(File.expand_path("#{__FILE__}/../../lib"))
$LOAD_PATH.unshift(File.expand_path("#{__FILE__}/../lib"))

require 'rack'
#require 'irb_drop'
require 'browsr'

app     = Rack::Builder.parse_file('rackup.ru').first
browser = Browsr.new(app)

Browser = browser
#irb_drop(binding)
