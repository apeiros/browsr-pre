require 'browsr/request'
require 'browsr/response'



class Browsr
  # A resource encompasses:
  # * The request object used to retrieve it
  # * The response object containing the headers and body
  # * Some additional meta information to facilitate working with it
  class Resource
    attr_reader   :request
    attr_reader   :response
    attr_reader   :data
    attr_reader   :site_uri
    attr_accessor :parent
    attr_accessor :loading_file
    attr_accessor :loading_line


    def initialize(request, response, meta=nil)
      @request  = request
      @response = response
      @data     = response.body
      @site_uri = request.uri.dup.tap { |uri|
        uri.fragment  = nil
        uri.query     = nil
      }
      if meta then
        @parent       = meta.delete :parent
        @loading_file = meta.delete :loading_file
        @loading_line = meta.delete :loading_line
      else
        @parent       = nil
        @loading_file = nil
        @loading_line = nil
      end
    end

    def site
      @request.uri.path
    end

    def uri
      @request.uri
    end
  end
  #Resource = Struct.new(:order, :type, :identifier, :file, :line, :data)
end
