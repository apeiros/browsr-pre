require 'uri'



class Browsr
  class Response
    class HeaderProxy < BasicObject
      def initialize(headers)
        @headers = Hash[headers.map { |key, value| [key.to_s.downcase, value] }]
      end

      def [](name)
        name = name.to_s.downcase
        @headers[name] || @headers[name.tr('_','-')] || @headers[name.tr('-','_')]
      end

      def to_hash
        @headers.dup
      end

      def to_s
        @headers.to_s
      end

      def inspect
        '#<%s %p>' % [::Module.nesting.first, @headers]
      end

      def method_missing(name, *args)
        raise ArgumentError, "Too many arguments" if args > 0
        if name =~ /?$/ then
          name = name[0..-2].downcase
          @headers.has_key?(name) || @headers.has_key?(name.tr('_','-')) || @headers.has_key?(name.tr('-','_'))
        else
          name = name.to_s.downcase
          @headers[name] || @headers[name.tr('_','-')] || @headers[name.tr('-','_')]
        end
      end
    end

    attr_reader :location, :headers, :body, :uri

    def initialize(request, headers, body)
      @request = request
      @headers = headers
      @body    = body
      @uri     = header('location') ? @request.uri + URI.parse(header('location')) : @request.uri
    end

    def header(name=nil)
      @header ||= HeaderProxy.new(@headers)
      name ? @header[name] : @header
    end
  end
end
