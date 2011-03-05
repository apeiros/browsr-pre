require 'browsr/css/properties'



class Browsr
  class CSS
    # A rule is a couple of property/value pairs sharing the same selector
    class Rule
      include Comparable

      attr_reader :properties, :selector

      def initialize(selector, properties={})
        @selector         = selector
        @properties       = Properties.new(properties)
      end

      def empty?
        @properties.empty?
      end

      def size
        @properties.size
      end

      def update(properties)
        @properties.update(properties)
      end

      def [](property)
        @properties[property.to_sym]
      end

      def []=(property, value)
        @properties[property.to_sym] = value
      end

      def <=>(other)
        @selector.specificity <=> other.selector.specificity
      end

      def to_s(indent=0, indent_str="\t")
        ind1 = indent_str * indent
        ind2 = indent_str + ind1
        %{#{ind1}#{@selector} {\n#{@properties.__hash__.map { |k,v| "#{ind2}#{k}: #{v};" }.join("\n")}\n#{ind1}}}
      end
      alias to_css to_s

      def inspect
        "\#<CSS::Rule(#{@selector}) #{@properties.to_css}>"
      end
    end
  end
end