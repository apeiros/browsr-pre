class Browsr
  class CSS
    module Expressions
      UNICODE     = /\\[0-9a-f]{1,6}(?:\r\n|[ \n\r\t\f])?/n
      ESCAPE      = /#{UNICODE}|\\[^\n\r\f0-9a-f]/n
      NONASCII    = /[^\x00-\x7f]/n
      NMSTART     = /[_a-z]|#{NONASCII}|#{ESCAPE}/n
      NMCHAR      = /[_a-z0-9-]|#{NONASCII}|#{ESCAPE}/n
      IDENT       = /-?#{NMSTART}#{NMCHAR}*/n
      NAME        = /#{NMCHAR}+/n
      NUMBER      = /\d+|\d*\.\d+/n
      NL          = /\r\n|[\n\r|\f]/n # newline
      STRING1     = /\"(?:[^\n\r\f\\"]|\\#{NL}|#{NONASCII}|#{ESCAPE})*\"/n
      STRING2     = /\'(?:[^\n\r\f\\']|\\#{NL}|#{NONASCII}|#{ESCAPE})*\'/n
      STRING      = /#{STRING1}|#{STRING2}/n
      INVALID1    = /\"(?:[^\n\r\f\\"]|\\{NL}|{NONASCII}|{ESCAPE})*/n
      INVALID2    = /\'(?:[^\n\r\f\\']|\\{NL}|{NONASCII}|{ESCAPE})*/n
      INVALID     = /#{INVALID1}|#{INVALID2}/n
      WHITESPACE  = /[ \t\r\n\f]/n

      INCLUDES        = /~=/n
      DASHMATCH       = /\|=/n
      PREFIXMATCH     = /\^=/n
      SUFFIXMATCH     = /\$=/n
      SUBSTRINGMATCH  = /\*=/n
      FUNCTION        = /#{IDENT}\(/n
      HASH            = /\##{NAME}/n
      PLUS            = /#{WHITESPACE}*\+/n
      GREATER         = /#{WHITESPACE}*\>/n
      COMMA           = /#{WHITESPACE}*,/n
      TILDE           = /#{WHITESPACE}*~/n
      NOT             = /:not\(/n
      ATKEYWORD       = /@#{IDENT}/n
      PERCENTAGE      = /{NUMBER}%/n
      DIMENSION       = /{NUMBER}{IDENT}/n
      CDO             = /<!--/n
      CDC             = /-->/n

      ELEMENT_NAME            = IDENT
      NAMESPACE_PREFIX        = /(?:#{IDENT}|\*)|\|/n
      KLASS                   = /\.#{IDENT}/n
      UNIVERSAL               = /#{NAMESPACE_PREFIX}?\*/n
      TYPE_SELECTOR           = /#{NAMESPACE_PREFIX}?#{ELEMENT_NAME}/n
      ATTRIB                  = /
        \[
        #{WHITESPACE}*
        #{NAMESPACE_PREFIX}?
        #{IDENT}
        #{WHITESPACE}*
        (?:
          (?:
            #{PREFIXMATCH}
            |#{SUFFIXMATCH}
            |#{SUBSTRINGMATCH}
            |=
            |#{INCLUDES}
            |#{DASHMATCH}
          )
          #{WHITESPACE}*
          (?:
            #{IDENT}
            |#{STRING}
          )
          #{WHITESPACE}*
        )?
        \]
      /n
      EXPRESSION                = /(?:(?:[+-]|#{DIMENSION}|#{NUMBER}|#{STRING}|#{IDENT})#{WHITESPACE}*)+/n
      FUNCTIONAL_PSEUDO         = /#{FUNCTION}#{WHITESPACE}*#{EXPRESSION}\)/n
      PSEUDO_CLASS              = /:(?:#{IDENT}|#{FUNCTIONAL_PSEUDO})/n
      PSEUDO_ELEMENT            = /:#{PSEUDO_CLASS}/n
      PSEUDO                    = /:?#{PSEUDO_CLASS}/n
      NEGATION_ARG              = /#{TYPE_SELECTOR}|#{UNIVERSAL}|\#|#{KLASS}|#{ATTRIB}|#{PSEUDO}/n
      NEGATION                  = /#{NOT}#{WHITESPACE}*#{NEGATION_ARG}#{WHITESPACE}*/n
      COMBINATOR                = /[\+>~]#{WHITESPACE}*|#{WHITESPACE}+/n
      SIMPLE_SELECTOR_SEQUENCE  = /(?:(?:#{TYPE_SELECTOR}|#{UNIVERSAL})(?:\#|#{KLASS}|#{ATTRIB}|#{PSEUDO}|#{NEGATION})*)|(?:\#|#{KLASS}|#{ATTRIB}|#{PSEUDO}|#{NEGATION})+/n
      SELECTOR                  = /#{SIMPLE_SELECTOR_SEQUENCE}(?:#{COMBINATOR}#{SIMPLE_SELECTOR_SEQUENCE})*/n
      SELECTORS_GROUP           = /#{SELECTOR}(?:,#{WHITESPACE}*#{SELECTOR})*/n

      # *** MINE ****
      AT_RULE             = ATKEYWORD
      COMMENT             = %r{/\*.*?\*/}n
      COLON               = /:/n
      IMPORTANT           = /!#{WHITESPACE}*important/n
      TERMINATE           = /;/n
      OPEN_BLOCK          = /\x7b/n # {
      CLOSE_BLOCK         = /\x7d/n # }
      CLOSE_PAREN         = /\x29/n # )
      ID_SELECTOR         = /\##{IDENT}/n
      CLASS_A_SELECTOR    = /#{ID_SELECTOR}|#{NOT}#{WHITESPACE}*#{ID_SELECTOR}#{WHITESPACE}*#{CLOSE_PAREN}/n
      CLASS_C_SELECTOR    = /#{TYPE_SELECTOR}|#{PSEUDO_ELEMENT}|#{NOT}#{WHITESPACE}*(?:#{TYPE_SELECTOR}|#{PSEUDO_ELEMENT})#{WHITESPACE}*#{CLOSE_PAREN}/n
      CLASS_B_SELECTOR    = /#{KLASS}|#{ATTRIB}|#{PSEUDO_CLASS}|#{NOT}#{WHITESPACE}*(?:#{KLASS}|#{ATTRIB}|#{PSEUDO_CLASS})#{WHITESPACE}*#{CLOSE_PAREN}/n
      UNIVERSAL_SELECTOR  = /#{UNIVERSAL}|#{NOT}#{WHITESPACE}*#{UNIVERSAL}#{WHITESPACE}*#{CLOSE_PAREN}/n
      ANYTHING            = %r{(?!/\*)[^\x7b;]*}n # \x7b == "{", ANYTHING is a stop-gap and should be removed
      ANYVAL              = %r{(?!/\*)[^;]*}n     # ANYVAL is a stop-gap and should be removed


      INHERIT       = /inherit/n
      DECIMAL       = /\d+/n
      FLOAT         = /\d+|\d*\.\d/n
      HEX           = /[\da-fA-F]/n
      RGBA_COLOR    = /rgba\(#{DECIMAL}\s*,#{DECIMAL}\s*,#{DECIMAL}\s*(?:\s*,#{FLOAT})?\)/n
      RGB_COLOR     = /rgb\(#{DECIMAL}\s*,#{DECIMAL}\s*,#{DECIMAL}\)/n
      HEX6_COLOR    = /\##{HEX}{6}/n
      HEX3_COLOR    = /\##{HEX}{3}/n
      COLOR_NAME    = /transparent|aqua|black|blue|fuchsia|gray|green|lime|maroon|navy|olive|purple|red|silver|teal|white|yellow/n
      COLOR         = Regexp.union(COLOR_NAME, HEX6_COLOR, HEX3_COLOR, RGB_COLOR, RGBA_COLOR)

      LENGTH        = /\d+px/n
      URL           = /url\(#{STRING}\)/n

      REPEAT        = /repeat|repeat(?:-[xy])?/n
      X_POSITION    = /#{PERCENTAGE}|#{LENGTH}|left|center|right/n
      Y_POSITION    = /#{PERCENTAGE}|#{LENGTH}|top|center|bottom/n
      POSITION      = /#{X_POSITION}\s+#{Y_POSITION}|#{Y_POSITION}\s+#{X_POSITION}|#{X_POSITION}|#{Y_POSITION}|inherit/n
      ATTACHMENT    = /scroll|fixed|inherit/n
      BORDER_STYLE  = /none|hidden|dotted|dashed|solid|double|groove|ridge|inset|outset|inherit/n
    end
  end
end
