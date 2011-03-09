require 'set'

class Browsr
  class CSS
    # The specification of a medium which can be used to be matched against a Media collection
    class Medium
      Default = {
        :type           => :screen,
        :resolution     => "96dpi",
        :width          => "1800px",
        :height         => "1000px",
        :device_width   => "1920px",
        :device_height  => "1200px",
        :orientation    => :landscape,
        :color          => 8,           # millions of colors (8 bit per color)
        :color_index    => 0,
        :monochrome     => 0,
      }

      attr_accessor :type
      attr_accessor :groups
      attr_accessor :resolution
      attr_accessor :width
      attr_accessor :height
      attr_accessor :device_width
      attr_accessor :device_height
      attr_accessor :orientation
      attr_accessor :color
      attr_accessor :color_index
      attr_accessor :monochrome
      attr_reader   :aspect_ratio
      attr_reader   :device_aspect_ratio

      def initialize(description)
        @type, @resolution, @width, @height, @device_width, @device_height,
          @orientation, @color, @color_index, @monochrome =
          Default.merge(description).values_at(:type, :resolution, :width,
          :height, :device_width, :device_height, :orientation, :color,
          :color_index, :monochrome)
        @groups = Set.new(description[:groups] || Media::TypeToGroups[@type])
        #@aspect_ratio         = Rational(to_pixel(@width), to_pixel(@height))
        #@device_aspect_ratio  = Rational(to_pixel(@device_width), to_pixel(@device_height))
      end

      def to_hash
        {
          :type           => @type,
          :resolution     => @resolution,
          :width          => @width,
          :height         => @height,
          :device_width   => @device_width,
          :device_height  => @device_height,
          :orientation    => @orientation,
          :color          => @color,
          :color_index    => @color_index,
          :monochrome     => @monochrome,
        }
      end

      def inspect
        sprintf "\#<%p %s>", self.class, to_hash.map { |key, value| "#{key}: #{value}" }.join(', ')
      end

      def ===(other)
        other.respond_to?(:media) && other.media === self
      end
      alias =~ ===
    private

      def to_pixel(value)
        
      end
    end
  end
end
