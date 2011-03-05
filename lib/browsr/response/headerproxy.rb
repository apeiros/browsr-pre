class Browsr
  class Response
    class HeaderProxy < BasicObject
      def initialize(headers)
        @headers = Hash[headers.map { |key, value| [key.to_s.tr('A-Z-', 'a-z_'), value] }]
      end

      def [](name)
        name = name.to_s..tr('A-Z-', 'a-z_')
        @headers[name]
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
          @headers.has_key?(name)
        else
          name = name.to_s.downcase
          @headers[name]
        end
      end
    end
  end
end
