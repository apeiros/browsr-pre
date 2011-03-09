require 'browsr/css/expressions'



class Browsr
  class CSS
    # Properties is a collection of properties
    # TODO:
    # * Complete decomposition
    # * Enable composition in #[] and decomposition in #[]=
    # * Add initial values
    class Properties
      DecomposeTopRightLeftBottom = proc { |top, right, bottom, left| proc { |property, value|
        values = value.split(/#{Expressions::WHITESPACE}+/n)
        # 1 value:  1: top, right, bottom & left
        # 2 values: 1: top & bottom, 2: left & right
        # 3 values: 1: top, 2: left & right, 3: bottom
        # 4 values: 1: top, 2: right, 3: bottom, 4: left
        case values.size
          when 1 then
            {
              top     => value,
              right   => value,
              bottom  => value,
              left    => value
            }
          when 2 then
            {
              top     => values.first,
              right   => values.last,
              bottom  => values.first,
              left    => values.last
            }
          when 3 then
            {
              top     => values[0],
              right   => values[1],
              bottom  => values[2],
              left    => values[1]
            }
          when 4 then
            {
              top     => values[0],
              right   => values[1],
              bottom  => values[2],
              left    => values[3]
            }
          else
            raise "Invalid number of values for #{property}"
        end
      }}
      DecomposeCopyToMany = proc { |*many|
        proc { |property, value|
          Hash[many.zip(Array.new(many.size, value))]
        }
      }
      # shorthands that are a collection of attributes in one, like border -> border-<location>
      DecomposeProperty = {
        :'border'       => DecomposeCopyToMany[:'border-top', :'border-right', :'border-bottom', :'border-left'],
        :'border-color' => DecomposeTopRightLeftBottom[:'border-top-color', :'border-right-color', :'border-bottom-color', :'border-left-color'],
        :'border-style' => DecomposeTopRightLeftBottom[:'border-top-style', :'border-right-style', :'border-bottom-style', :'border-left-style'],
        :'border-width' => DecomposeTopRightLeftBottom[:'border-top-width', :'border-right-width', :'border-bottom-width', :'border-left-width'],
      }
      # shorthands that are a collection of values
      DecomposeValue = {
        :background => {
          Expressions::COLOR        => :'background-color',
          Expressions::URL          => :'background-image',
          Expressions::REPEAT       => :'background-repeat',
          Expressions::POSITION     => :'background-position',
          Expressions::ATTACHMENT   => :'background-attachment'
        },
        :'border' => {
          Expressions::BORDER_STYLE => :'border-style',
          Expressions::COLOR        => :'border-color',
          Expressions::LENGTH       => :'border-width'
        },
        :'border-top' => {
          Expressions::BORDER_STYLE => :'border-top-style',
          Expressions::COLOR        => :'border-top-color',
          Expressions::LENGTH       => :'border-top-width'
        },
        :'border-right' => {
          Expressions::BORDER_STYLE => :'border-right-style',
          Expressions::COLOR        => :'border-right-color',
          Expressions::LENGTH       => :'border-right-width'
        },
        :'border-bottom' => {
          Expressions::BORDER_STYLE => :'border-bottom-style',
          Expressions::COLOR        => :'border-bottom-color',
          Expressions::LENGTH       => :'border-bottom-width'
        },
        :'border-left' => {
          Expressions::BORDER_STYLE => :'border-left-style',
          Expressions::COLOR        => :'border-left-color',
          Expressions::LENGTH       => :'border-left-width'
        },
        #:font       => [:font_family, :font_size, ]
      }

      # @returns [Hash]
      def self.decompose(name, value)
        result = {}
        decompose_value = DecomposeValue[name] # more expensive usually, so do that first
        if decompose_value then
          original_value = value
          decompose_value.each do |regex, prop|
            value = value.sub(regex) { |val|
              result.update(decompose(prop, val))
              ''
            }.strip
          end
          raise "Incomplete decomposition of #{name.inspect}, residue: #{value.inspect}, original: #{original_value.inspect}" unless value.empty?
        else
          decompose_property  = DecomposeProperty[name]
          if decompose_property then
            decomposed = decompose_property[name, value]
            result.update(decomposed)
          else
            result[name] = value
          end
        end

        result
      end

      # Create a single set of properties from a couple of rules
      def self.merge_rules(rules)
        properties = Properties.new
        rules.sort.each do |rules|
          properties.update(rules.properties)
        end

        properties
      end

      def empty?
        @__hash__.empty?
      end

      def size
        @__hash__.size
      end

      # This is the internal hash-table, used for internal purposes. Use with care.
      attr_reader :__hash__

      def initialize(properties_hash={})
        @__hash__ = properties_hash
      end

      # Add multiple values at once
      def update(properties)
        @__hash__.update(properties)
      end

      # Add values that are set to 'inherit'
      # Returns nil if all properties which should inherit have been set to a
      # final value, the property names otherwise otherwise
      def inherit(properties, names=nil)
        names ||= @__hash__.select { |key, value| value == :inherit }.map(&:first)

        names.reject do |name|
          inherited = properties[name]
          if inherited && inherited != :inherit then
            @__hash__[name] = inherited
            true
          else
            false
          end
        end
      end

      # unlike [], this does not perform any normalization or composition and is
      # therefore the fastest access.
      # For that reason it also only works for decomposed names.
      # Property names must be given as a Symbol matching
      # the css spec exactly. Example: properties.at(:'border-left-style')
      # IMPORTANT: properties.at(:'border') won't work since 'border' is a
      # composed property. Use #[] for that.
      def at(property)
        @__hash__[property]
      end

      def [](property)
        @__hash__[property.to_sym]
      end

      def []=(property, value)
        @__hash__[property.to_sym] = value
      end

      def method_missing(original_name, *args)
        name   = original_name
        exists = @__hash__.has_key?(name)
        unless exists then
          name = original_name.to_s.tr('_','-').to_sym
          exists = @__hash__.has_key?(name)
        end

        if exists then
          raise ArgumentError, "Too many arguments" unless args.empty?
          @__hash__[name]
        else
          super
        end
      end

      def respond_to_missing?(name, include_private)
        @__hash__.has_key?(name) || @__hash__.has_key?(name.to_s.tr('_','-').to_sym)
      end

      def to_css
        @__hash__.map { |k,v| "#{k}: #{v};" }.join(" ")
      end
      alias to_s to_css

      def to_hash
        @__hash__.dup
      end

      def inspect
        sprintf "\#<%p: %s>", self.class, self
      end
    end # Properties
  end # CSS
end # Browsr
