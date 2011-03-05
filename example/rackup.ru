$:.unshift(File.expand_path(File.dirname(__FILE__))+"/lib")
require 'pp'
require 'servr'

use Rack::CommonLogger
use Rack::ShowExceptions
servr = Servr.new(File.expand_path('../webroot', __FILE__))
run servr
