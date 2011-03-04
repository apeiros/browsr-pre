require 'strscan'


# Scenarios:
# * load stylesheet via style attribute
# * load stylesheet via link tag
# * load stylesheet via link
# * load stylesheet via @import (treated as "loaded before the current file")
# * unload stylesheet (nb: @import'ed stylesheets become unloaded too; unloads can happen upon deletion of a <link>
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
# -> media -> selector -> origin -> ruleset -> rule
#   {
#     :screen => {
#       "#my-foo" => {
#         :user_agent_stylesheet => {
#           :opacity => 0.8
#         }
#       }
#     }
#   }
# -> by stylesheet
# @media = :all, :braille, :embossed, :handheld, :print, :projection, :screen, :speech, :tty, :tv - default = :screen
# @stylesheets


class Tokenizer
  module Expression
    Unicode     = /\\[0-9a-f]{1,6}(?:\r\n|[ \n\r\t\f])?/n
    Escape      = /#{Unicode}|\\[^\n\r\f0-9a-f]/n
    Nonascii    = /[^\x00-\x7f]/n
    Nmstart     = /[_a-z]|#{Nonascii}|#{Escape}/n
    Nmchar      = /[_a-z0-9-]|#{Nonascii}|#{Escape}/n
    Ident       = /-?#{Nmstart}#{Nmchar}*/n
    Name        = /#{Nmchar}+/n
    Num         = /\d+|\d*\.\d+/n
    Nl          = /\r\n|[\n\r|\f]/n
    String1     = /\"(?:[^\n\r\f\\"]|\\#{Nl}|#{Nonascii}|#{Escape})*\"/n
    String2     = /\'(?:[^\n\r\f\\']|\\#{Nl}|#{Nonascii}|#{Escape})*\'/n
    String      = /#{String1}|#{String2}/n
    Invalid1    = /\"(?:[^\n\r\f\\"]|\\{Nl}|{Nonascii}|{Escape})*/n
    Invalid2    = /\'(?:[^\n\r\f\\']|\\{Nl}|{Nonascii}|{Escape})*/n
    Invalid     = /#{Invalid1}|#{Invalid2}/n
    Whitespace  = /[ \t\r\n\f]/n
    D           = /d|\\0{0,4}(?:44|64)(?:\r\n|[ \t\r\n\f])?/n
    E           = /e|\\0{0,4}(?:45|65)(?:\r\n|[ \t\r\n\f])?/n
    N           = /n|\\0{0,4}(?:4e|6e)(?:\r\n|[ \t\r\n\f])?|\\n/n
    O           = /o|\\0{0,4}(?:4f|6f)(?:\r\n|[ \t\r\n\f])?|\\o/n
    T           = /t|\\0{0,4}(?:54|74)(?:\r\n|[ \t\r\n\f])?|\\t/n
    V           = /v|\\0{0,4}(?:58|78)(?:\r\n|[ \t\r\n\f])?|\\v/n

    INCLUDES        = /~=/n
    DASHMATCH       = /\|=/n
    PREFIXMATCH     = /\^=/n
    SUFFIXMATCH     = /\$=/n
    SUBSTRINGMATCH  = /\*=/n
    IDENT           = /#{Ident}/n
    STRING          = /#{String}/n
    FUNCTION        = /#{Ident}\(/n
    NUMBER          = /#{Num}/n
    HASH            = /\##{Name}/n
    PLUS            = /#{Whitespace}*\+/n
    GREATER         = /#{Whitespace}*\>/n
    COMMA           = /#{Whitespace}*,/n
    TILDE           = /#{Whitespace}*~/n
    NOT             = /:#{N}#{O}#{T}"("/n
    ATKEYWORD       = /@{Ident}/n
    INVALID         = /{Invalid}/n
    PERCENTAGE      = /{Num}%/n
    DIMENSION       = /{Num}{Ident}/n
    CDO             = /<!--/n
    CDC             = /-->/n

    SelectorsGroup          = /#{Selector}(?:,#{Whitespace}*#{Selector})*/n
    Selector                = /#{SimpleSelectorSequence}(?:#{Combinator}#{SimpleSelectorSequence})*/n
    Combinator              = /[\+>~]#{Whitespace}*|#{Whitespace}+/n
    SimpleSelectorSequence  = /(?:(?:#{TypeSelector}|#{Universal})(?:\#|#{Klass}|#{Attrib}|#{Pseudo}|#{Negation})*)|(?:\#|#{Klass}|#{Attrib}|#{Pseudo}|#{Negation})+/n
    TypeSelector            = /#{NamespacePrefix}?#{ElementName}/n
    NamespacePrefix         = /(?:#{Ident}|\*)|\|/n
    ElementName             = Ident
    Universal               = /#{NamespacePrefix}?\*/n
    Klass                   = /\.#{Ident}/n
    Attrib                  = /
      \[
      #{Whitespace}*
      #{NamespacePrefix}?
      #{Ident}
      #{Whitespace}*
      (?:
        (?:
          #{PREFIXMATCH}
          |#{SUFFIXMATCH}
          |#{SUBSTRINGMATCH}
          |=
          |#{INCLUDES}
          |#{DASHMATCH}
        )
        #{Whitespace}*
        (?:
          #{Ident}
          |#{String}
        )
        #{Whitespace}*
      )?
      \]
    /n
    Pseudo                  = /::?(?:#{Ident}|#{FunctionalPseudo})/n
    FunctionalPseudo        = /#{Function}#{Whitespace}*#{Expression}\)/n
    Expression              = /(?:(?:[+-]|#{Dimension}|#{Number}|#{String}|#{Ident})#{Whitespace}*)+/n
    Negation                = /#{Not}#{Whitespace}*#{NegationArg}#{Whitespace}*/n
    NegationArg             = /#{TypeSelector}|#{Universal}|\#|#{Klass}|#{Attrib}|#{Pseudo}/n
  end

  attr_reader   :string, :scanner
  attr_accessor :context
  def initialize()
    @context = :rule # :rule, :multiline_comment, :singleline_comment (does not really exist, so what),
                     # :
    @expect  = [[:selector], [:whitespace], [:at_rule]]
    @stack   = []
    @file    = nil
    @line    = nil
    @scanner = nil
  end

  def parse_link_tag(string, file, line)
    @file     = file
    @line     = line
    @scanner  = StringScanner.new(string)
    parse
  end

  def parse
    until @scanner.eof?
      case @context
        when :rule
          case
            when @scanner.scan(/@#{Expressions::Ident}/) then
              @expect = [[:whitespace, 
            when @scanner.scan(/
      end
    end
  end
end
