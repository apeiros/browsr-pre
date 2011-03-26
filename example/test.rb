lib1 = File.expand_path("#{__FILE__}/../../lib")
lib2 = File.expand_path("#{__FILE__}/../lib")
$LOAD_PATH.unshift(lib1) unless $LOAD_PATH.include?(lib1)
$LOAD_PATH.unshift(lib2) unless $LOAD_PATH.include?(lib2)
rackup_file = File.expand_path('../rackup.ru', __FILE__)

require 'rack'
require 'browsr'

app = Rack::Builder.parse_file(rackup_file).first
B   = Browsr.rack(app)

puts "The browser is available via the constant 'B'"
