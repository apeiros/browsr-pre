require 'browsr/css/expressions'



class Browsr
  class CSS
    # Properties is a collection of properties
    class Properties
      DecomposeTopRightLeftBottom = proc { |top, right, bottom, left| proc { |property, value, top, right, bottom, left|
        values = value.split(/#{Expressions::Whitespace}+/n)
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
      DecomposeCopyToMany = proc { |*many| proc { |property, value, *many|
        result = Hash[many.zip(Array.new(many.size, value))]
      }}
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
          Expressions::COLOR      => :'background-color',
          Expressions::URL        => :'background-image',
          Expressions::REPEAT     => :'background-repeat',
          Expressions::POSITION   => :'background-position',
          Expressions::ATTACHMENT => :'background-attachment'
        },
        :'border-top' => {
          Expressions::BORDER_STYLE => :'border-top-style',
          Expressions::COLOR        => :'border-top-color',
          Expressions::LENGTH       => :'border-top-width'
        },
        :'border-right' => {
          Expressions::BORDER_STYLE  => :'border-right-style',
          Expressions::COLOR         => :'border-right-color',
          Expressions::LENGTH        => :'border-right-width'
        },
        :'border-bottom' => {
          Expressions::BORDER_STYLE  => :'border-bottom-style',
          Expressions::COLOR         => :'border-bottom-color',
          Expressions::LENGTH        => :'border-bottom-width'
        },
        :'border-left' => {
          Expressions::BORDER_STYLE  => :'border-left-style',
          Expressions::COLOR         => :'border-left-color',
          Expressions::LENGTH        => :'border-left-width'
        },
        #:font       => [:font_family, :font_size, ]
      }

      def self.merge_rules(rules)
        properties = Properties.new
        rules.sort.each do |rules|
          properties.update(rules.properties)
        end

        properties
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

      def method_missing(original_name, *args)
        name   = original_name
        exists = @properties.has_key?(name)
        unless exists then
          name = original_name.to_s.tr('_','-').to_sym
          exists = @properties.has_key?(name)
        end

        if exists then
          raise ArgumentError, "Too many arguments" unless args.empty?
          @properties[name]
        else
          super
        end
      end

      def respond_to_missing?(name)
        @properties.has_key?(name) || @properties.has_key?(name.to_s.tr('_','-').to_sym)
      end

      def to_css
        @properties.map { |k,v| "#{k}: #{v};" }.join(" ")
      end
      alias to_s to_css

      def to_hash
        @properties.dup
      end

      def inspect
        sprintf "\#<%p: %s>", self.class, self
      end
    end # Properties
  end # CSS
end # Browsr
