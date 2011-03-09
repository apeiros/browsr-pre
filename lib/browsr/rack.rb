require 'rack'

class Browsr
  module Rack
    def self.use
      Browsr::Response.extend RackResponseClass unless Browsr::Response.is_a?(RackResponseClass)
    end

    module RackBrowsr
      # @param [#call] app
      #   a Rack app, in other words: anything that responds to #call with a
      # @param [Hash] response
      # acceptable by Rack.
      def initialize_rack(app, options={})
        @mock_request = ::Rack::MockRequest.new(app)
      end

      # @see Browsr#get
      def get(page, headers={})
        request  = Request.new(page, headers)
        response = Response.rack_mock_response(request, @mock_request.get(page.to_s))

        Resource.new(request, response)
      end
    end

    module RackResponseClass
      def rack_mock_response(request, mock_response)
        Response.new(mock_response.status, mock_response.original_headers, mock_response.body)
      end
    end
  end
end
