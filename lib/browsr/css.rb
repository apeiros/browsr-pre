require 'rational'
require 'set'
require 'browsr/css/expressions'
require 'browsr/css/media'
require 'browsr/css/mediaquery'
require 'browsr/css/medium'
require 'browsr/css/parser'
require 'browsr/css/properties'
require 'browsr/css/rule'
require 'browsr/css/ruleset'
require 'browsr/css/selector'

class Browsr

  # Scenarios:
  # * load stylesheet via style attribute
  # * load stylesheet via link tag
  # * load stylesheet via link
  # * load stylesheet via @import (treated as "loaded before the current file")
  # * unload stylesheet (nb: @import'ed stylesheets become unloaded too; unloads can happen upon deletion of a <link>
  #
  # Assumptions:
  # * unloading a stylesheet is rare
  # * loading a stylesheet late (DOM scripting) is rare
  # * change of medium/media-query-values is rare
  # * actually querying css is uncommon (more often than rare, still not very often)
  # -> wait with parsing css until an actual query is performed
  # -> don't handle media queries dynamically, handle them at load time
  #
  # I need:
  # * file
  # * line
  # * specificity (origin + css-specificity + position)
  # * media (ignore different media)
  #
  # Terminology:
  # * source:           file & line something occurred
  # * selector:         the css selector, e.g. "#foo > bar[title="baz"]"
  # * ruleset:          a collection (by selector) of rules
  # * rule:             a structure containing a single property-value rule (e.g. "opacity: 0.8") along with its specificity and source
  # * specificity:      (origin + css-specificity + position)
  # * css-specificity:  specificity as specified by css
  #
  # Structure:
  #   ruleset(media) -> rule(selector/specificity) -> property
  #   => [RuleSet(Rule, Rule, ...), RuleSet(Rule, Rule, ...), ...]
  #
  class CSS
    include Enumerable

    attr_accessor :position
    attr_reader   :rulesets, :by_media

    # default_loader:
    #   gets a string yielded with a relative url and should return the
    #   corresponding body
    def initialize(&default_loader)
      @rulesets = []
      @by_media = {}
      @position = 0
    end

    def each(&block)
      @rulesets.each(&block)
    end

    # source is merged before importing, relevant for specificity
    def import(importing, source, &loader)
      raise "@import rule is currently not handled"
      return if @imported.include?(source)
    end

    # string [String] the stylesheet data as a string
    # origin [Symbol] the origin of the data, e.g. :author_style_sheet
    # media  [Browsr::CSS::Media] 
    # file   [String] the source file, used for error reports
    # line   [Integer] The starting line number, used for error reports
    def append_external_stylesheet(string, origin, media, file, line=1, &loader)
      parser = Parser.new(self, string, origin, media, file, line) do |import|
        raise "@import not yet implemented"
      end
      parser.parse
    end

    def add_rule(media, rule)
      ruleset = find_or_create_ruleset(media)
      ruleset.update(rule)
    end

    def find_or_create_ruleset(media)
      found = @by_media[media]
      return found if found
      created = RuleSet.new(media)
      @by_media[media] = created
      @rulesets       << created
      created
    end

    def computed_style_for_nokogiri(dom, node, medium=Medium.new(:type => :screen))
      # get all rules whose media queries are satisfied by the medium
      rules = grep(medium).map { |ruleset| ruleset.rules }

      # get all rulesets that match the specified node
      applying_rules = rules.map { |rulehash|
        rulehash.select { |selector, rule|
          dom.css(selector).include?(node)
        }.map { |selector, rule|
          rule
        }
      }.flatten(1)

      # merge rulesets in order of specificity
      Properties.merge_rules(applying_rules)
    end
  end
end
