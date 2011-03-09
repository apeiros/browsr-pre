require 'uri'
require 'browsr/httpheaders'



class Browsr
  # Stores parameters of a request to perform. Can also generate "Dataset" like
  # copies of itself to facilitate performing multiple similar requests.
  # Example:
  #   standard_request = Request.uri "http://127.0.0.1", :user_agent => "FakeUA"
  #   with_cookie      = standard_request.cookie(...)
  #   
  class Request
    attr_reader :uri
    attr_reader :headers
    attr_reader :method
    attr_reader :body

    def initialize(uri, headers={}, method=:get, body=nil)
      @uri      = uri.is_a?(URI) ? uri : URI.parse(uri)
      @headers  = HTTPHeaders.new(headers)
      @method   = method
      @body     = body
    end
  end
end
