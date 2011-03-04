require 'uri'



class Browsr
  class Request
    attr_reader :uri

    def initialize(uri)
      @uri = uri.is_a?(URI) ? uri : URI.parse(uri)
    end
  end
end
