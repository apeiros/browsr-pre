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
    attr_accessor :position
    attr_reader   :rulesets, :by_media

    def initialize(&default_loader)
      @rulesets = []
      @by_media = {}
      @position = 0
    end

    # source is merged before importing, relevant for specificity
    def import(importing, source, &loader)
      raise "@import rule is currently not handled"
      return if @imported.include?(source)
    end

    def append_external_stylesheet(data, source, line=1, &loader)
      parser = Parser.new(self, source, line, @options) do |import|
        append_parsed_stylesheet()
      end
      parser.parse(data)
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

    def append_parsed_stylesheet(stylesheet)
    end

    def parse_stylesheet(data, source, line)
    end

    def parse_style_tag(data, source, line)
    end

    def parse_style_attribute(data, source, line)
    end

    def computed_style_for_nokogiri(dom, node, medium=Medium.new([:screen],nil,nil))
      # get all rules whose media queries are satisfied by the medium
      rules = @rulesets.grep(medium).map { |ruleset| ruleset.rules }.flatten(1)

      # get all rulesets that match the specified node
      applying_rules = rules.select { |rule|
        dom.css(rule.selector).include?(node)
      }

      # merge rulesets in order of specificity
      Properties.merge_rules(applying_rules)
    end
  end
end
