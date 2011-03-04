require 'set'

class Browsr
  class CSS
    # A collection of Media that can be used to match against a Medium
    class Media
      All           = [:braille, :embossed, :handheld, :print, :projection, :screen, :speech, :tty, :tv]
      DefaultMedium = :screen
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

      # FIXME: not yet implemented
      def self.parse(string)
        new([:all], nil, nil)
      end

      attr_reader :types, :groups, :queries

      def initialize(types, groups, queries)
        if types.nil? || types.empty? then
          @types = Set.new([DefaultMedium])
        elsif types.include?(:all)
          @types = Set.new((All - [:all]) | types)
        else
          @types = Set.new(types)
        end

        @groups = Set.new(groups || [])

        @queries = queries || []
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

      def inspect
        sprintf "\#<%p types: %s; groups: %s; queries: ?>",
          self.class,
          @types.empty? ? '-' : @types.to_a.sort.join(', '),
          @groups.empty? ? '-' : @groups.to_a.sort.join(', ')
      end
    end
  end
end
