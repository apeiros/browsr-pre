require 'browsr/css/properties'



class Browsr
  class CSS
    # A rule is a couple of property/value pairs sharing the same selector
    class Rule
      include Comparable

      # @returns [Hash]
      def self.decompose(name, value)
        result = {}
        decompose_property  = DecomposeProperty[property]
        if decompose_property then
          decompose_property.reverse_each do |decompose_to|
            properties.unshift [decompose_to, value]
          end
        else
          decompose_value = DecomposeValue[property]
          if decompose_value then
            decompose_value.each do |regex, prop|
              #p :decompose_value => [value, regex, prop, value[regex]]
              value = value.gsub(regex) do |val|
                result[prop] = val
                ''
              end
            end
          else
            result[property] = value
          end
        end
      end

      attr_reader   :position, :selector, :properties, :css_specificity
      attr_accessor :specificity

      def initialize(selector, properties, css_specificity=0, position=0)
        @selector         = selector
        @css_specificity  = css_specificity
        @specificity      = css_specificity | position
        @properties       = Properties.new(properties)
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

      def to_s(indent=0, indent_str="\t")
        ind1 = indent_str * indent
        ind2 = indent_str + ind1
        %{#{ind1}#{@selector} {\n#{@properties.map { |k,v| "#{ind2}#{k}: #{v};" }.join("\n")}\n#{ind1}}}
      end

      def inspect
        "\#<CSS::Rule(#{@selector}) #{to_css}>"
      end
    end
  end
end