require 'rack'
Server = Rack::Builder.parse_file('rackup.ru').first
MReq   = Rack::MockRequest.new(Server)
