lib1 = File.expand_path("#{__FILE__}/../../lib")
lib2 = File.expand_path("#{__FILE__}/../lib")
$LOAD_PATH.unshift(lib1) unless $LOAD_PATH.include?(lib1)
$LOAD_PATH.unshift(lib2) unless $LOAD_PATH.include?(lib2)

require 'rack'
#require 'irb_drop'
require 'browsr'

app     = Rack::Builder.parse_file('rackup.ru').first
browser = Browsr.rack(app)

Browser = browser
#irb_drop(binding)
