require 'set'

class Browsr
  class CSS
    # A collection of Media that can be used to match against a Medium
    #
    # TODO:
    # * implement media groups properly
    # * implement media queries
    # * implement combining media
    # * implement simplifying queries (e.g. "all and screen" -> "all", "max-width: 200px and max-width: 400px" -> "max-width: 200px" etc.)
    class Media
      GroupToTypes  = Hash.new { |_, group| raise ArgumentError, "Unknown group #{group.inspect}" }.merge({
        :continuous   => [:braille, :handheld, :screen, :speec, :tty, :tv],
        :paged        => [:embossed, :handheld, :print, :projection, :tv],
        :visual       => [:handheld, :print, :projection, :screen, :tv],
        :audio        => [:handheld, :screen, :tv],
        :speech       => [:handheld, :speech],
        :tactile      => [:braille, :embossed],
        :grid         => [:braille, :embossed, :handheld, :tty],
        :bitmap       => [:handheld, :print, :projection, :screen, :tv],
        :interactive  => [:braille, :handheld, :projection, :screen, :speech, :tty, :tv],
        :static       => [:braille, :embossed, :handheld, :print, :screen, :speech, :tty, :tv],
      })
      TypeToGroups  = Hash.new { |_, medium| raise ArgumentError, "Unknown medium #{medium.inspect}" }.merge({
        :braille      => [:continuous, :tactile, :grid, :interactive, :static],
        :embossed     => [:paged, :tactile, :grid, :static],
        :handheld     => [:continuous, :paged, :visual, :audio, :speech, :grid, :bitmap, :interactive, :static],
        :print        => [:paged, :visual, :bitmap, :static],
        :projection   => [:paged, :visual, :bitmap, :interactive],
        :screen       => [:continuous, :visual, :audio, :bitmap, :interactive, :static],
        :speech       => [:continuous, :paged, :visual, :audio, :speech, :tactile, :interactive, :static],
        :tty          => [:continuous, :visual, :grid, :interactive, :static],
        :tv           => [:continuous, :paged, :visual, :audio, :bitmap, :interactive, :static],
      })
      AllTypes      = [:braille, :embossed, :handheld, :print, :projection, :screen, :speech, :tty, :tv]
      AllGroups     = GroupToTypes.keys
      DefaultType   = Set.new([:screen])
      DefaultGroups = Set.new(TypeToGroups[:screen])
      

      # FIXME: not yet implemented
      def self.parse(string)
        new([:all], nil, nil)
      end

      attr_reader :types, :groups, :queries

      def initialize(types, groups, queries)
        if types.nil? || types.empty? then
          @types = DefaultType.dup
        elsif types.include?(:all)
          @types = Set.new((AllTypes - [:all]) | types) # `| types` in case of unknown types
        else
          @types = Set.new(types)
        end

        if groups.nil? || groups.empty? then
          @groups = DefaultGroups.dup
        elsif groups.include?(:all)
          @groups = Set.new((DefaultGroups - [:all]) | groups) # `| groups` in case of unknown groups
        else
          @groups = Set.new(groups)
        end

        @queries = [] #queries || []
      end

      def +(other_media)
        Medium.new(@types | other_media.types, @groups | other_media.groups, @queries | other.queries)
      end

      def =~(medium)
#         p :not_medium_type => !medium.type,
#           :medium_type     => (!medium.type || @types.include?(medium.type)),
#           :not_groups      => !medium.groups,
#           :groups          => (!medium.groups || @groups.superset?(medium.groups)),
#           :queries         => @queries.all? { |query| query =~ medium }
        (
          (!medium.type || @types.include?(medium.type)) &&
          true && # FIXME, groups don't work like that, must test on individual group type... (!medium.groups || @groups.superset?(medium.groups)) &&
          @queries.all? { |query| query =~ medium }
        )
      end
      alias === =~

      def hash
        [@types, @groups, @queries].hash
      end

      def eql?(other)
        [@types, @groups, @queries].eql?([other.types, other.groups, other.queries])
      end

      def inspect
        sprintf "\#<%p types: %s; groups: %s; queries: ?>",
          self.class,
          @types.empty? ? '-' : @types.to_a.sort.join(', '),
          @groups.empty? ? '-' : @groups.to_a.sort.join(', ')
      end
    end
  end
end
