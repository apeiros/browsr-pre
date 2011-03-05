class Browsr
  class CSS
    module Expressions
      UNICODE     = /\\[0-9a-f]{1,6}(?:\r\n|[ \n\r\t\f])?/ni
      ESCAPE      = /#{UNICODE}|\\[^\n\r\f0-9a-f]/ni
      NONASCII    = /[^\x00-\x7f]/ni
      NMSTART     = /[_a-z]|#{NONASCII}|#{ESCAPE}/ni
      NMCHAR      = /[_a-z0-9-]|#{NONASCII}|#{ESCAPE}/ni
      IDENT       = /-?#{NMSTART}#{NMCHAR}*/ni
      NAME        = /#{NMCHAR}+/ni
      NUMBER      = /\d+|\d*\.\d+/ni
      NL          = /\r\n|[\n\r|\f]/ni # newline
      STRING1     = /\"(?:[^\n\r\f\\"]|\\#{NL}|#{NONASCII}|#{ESCAPE})*\"/ni
      STRING2     = /\'(?:[^\n\r\f\\']|\\#{NL}|#{NONASCII}|#{ESCAPE})*\'/ni
      STRING      = /#{STRING1}|#{STRING2}/ni
      INVALID1    = /\"(?:[^\n\r\f\\"]|\\{NL}|{NONASCII}|{ESCAPE})*/ni
      INVALID2    = /\'(?:[^\n\r\f\\']|\\{NL}|{NONASCII}|{ESCAPE})*/ni
      INVALID     = /#{INVALID1}|#{INVALID2}/ni
      WHITESPACE  = /[ \t\r\n\f]/ni

      INCLUDES        = /~=/ni
      DASHMATCH       = /\|=/ni
      PREFIXMATCH     = /\^=/ni
      SUFFIXMATCH     = /\$=/ni
      SUBSTRINGMATCH  = /\*=/ni
      FUNCTION        = /#{IDENT}\(/ni
      HASH            = /\##{NAME}/ni
      PLUS            = /#{WHITESPACE}*\+/ni
      GREATER         = /#{WHITESPACE}*\>/ni
      COMMA           = /#{WHITESPACE}*,/ni
      TILDE           = /#{WHITESPACE}*~/ni
      NOT             = /:not\(/ni
      ATKEYWORD       = /@#{IDENT}/ni
      PERCENTAGE      = /{NUMBER}%/ni
      DIMENSION       = /{NUMBER}{IDENT}/ni
      CDO             = /<!--/ni
      CDC             = /-->/ni

      ELEMENT_NAME            = IDENT
      NAMESPACE_PREFIX        = /(?:#{IDENT}|\*)|\|/ni
      KLASS                   = /\.#{IDENT}/ni
      UNIVERSAL               = /#{NAMESPACE_PREFIX}?\*/ni
      TYPE_SELECTOR           = /#{NAMESPACE_PREFIX}?#{ELEMENT_NAME}/ni
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
      /ni
      EXPRESSION                = /(?:(?:[+-]|#{DIMENSION}|#{NUMBER}|#{STRING}|#{IDENT})#{WHITESPACE}*)+/ni
      FUNCTIONAL_PSEUDO         = /#{FUNCTION}#{WHITESPACE}*#{EXPRESSION}\)/ni
      PSEUDO_CLASS              = /:(?:#{IDENT}|#{FUNCTIONAL_PSEUDO})/ni
      PSEUDO_ELEMENT            = /:#{PSEUDO_CLASS}/ni
      PSEUDO                    = /:?#{PSEUDO_CLASS}/ni
      NEGATION_ARG              = /#{TYPE_SELECTOR}|#{UNIVERSAL}|\#|#{KLASS}|#{ATTRIB}|#{PSEUDO}/ni
      NEGATION                  = /#{NOT}#{WHITESPACE}*#{NEGATION_ARG}#{WHITESPACE}*/ni
      COMBINATOR                = /[\+>~]#{WHITESPACE}*|#{WHITESPACE}+/ni
      SIMPLE_SELECTOR_SEQUENCE  = /(?:(?:#{TYPE_SELECTOR}|#{UNIVERSAL})(?:\#|#{KLASS}|#{ATTRIB}|#{PSEUDO}|#{NEGATION})*)|(?:\#|#{KLASS}|#{ATTRIB}|#{PSEUDO}|#{NEGATION})+/ni
      SELECTOR                  = /#{SIMPLE_SELECTOR_SEQUENCE}(?:#{COMBINATOR}#{SIMPLE_SELECTOR_SEQUENCE})*/ni
      SELECTORS_GROUP           = /#{SELECTOR}(?:,#{WHITESPACE}*#{SELECTOR})*/ni

      # *** MINE ****
      AT_RULE             = ATKEYWORD
      COMMENT             = %r{/\*.*?\*/}nim
      COLON               = /:/ni
      IMPORTANT           = /!#{WHITESPACE}*important/ni
      TERMINATE           = /;/ni
      OPEN_BLOCK          = /\x7b/ni # {
      CLOSE_BLOCK         = /\x7d/ni # }
      CLOSE_PAREN         = /\x29/ni # )
      ID_SELECTOR         = /\##{IDENT}/ni
      CLASS_A_SELECTOR    = /#{ID_SELECTOR}|#{NOT}#{WHITESPACE}*#{ID_SELECTOR}#{WHITESPACE}*#{CLOSE_PAREN}/ni
      CLASS_B_SELECTOR    = /#{KLASS}|#{ATTRIB}|#{PSEUDO_CLASS}|#{NOT}#{WHITESPACE}*(?:#{KLASS}|#{ATTRIB}|#{PSEUDO_CLASS})#{WHITESPACE}*#{CLOSE_PAREN}/ni
      CLASS_C_SELECTOR    = /#{TYPE_SELECTOR}|#{PSEUDO_ELEMENT}|#{NOT}#{WHITESPACE}*(?:#{TYPE_SELECTOR}|#{PSEUDO_ELEMENT})#{WHITESPACE}*#{CLOSE_PAREN}/ni
      UNIVERSAL_SELECTOR  = /#{UNIVERSAL}|#{NOT}#{WHITESPACE}*#{UNIVERSAL}#{WHITESPACE}*#{CLOSE_PAREN}/ni
      ANYTHING            = %r{(?!/\*)[^\x7b;]*}ni # \x7b == "{", ANYTHING is a stop-gap and should be removed
      ANYVAL              = %r{(?!/\*)[^;]*}ni     # ANYVAL is a stop-gap and should be removed


      INHERIT       = /inherit/ni
      DECIMAL       = /\d+/ni
      FLOAT         = /\d+|\d*\.\d/ni
      HEX           = /[\da-fA-F]/ni
      RGBA_COLOR    = /rgba\(#{DECIMAL}\s*,#{DECIMAL}\s*,#{DECIMAL}\s*(?:\s*,#{FLOAT})?\)/ni
      RGB_COLOR     = /rgb\(#{DECIMAL}\s*,#{DECIMAL}\s*,#{DECIMAL}\)/ni
      HEX6_COLOR    = /\##{HEX}{6}/ni
      HEX3_COLOR    = /\##{HEX}{3}/ni
      COLOR_NAME    = /transparent|aqua|black|blue|fuchsia|gray|green|lime|maroon|navy|olive|purple|red|silver|teal|white|yellow/ni
      COLOR         = Regexp.union(COLOR_NAME, HEX6_COLOR, HEX3_COLOR, RGB_COLOR, RGBA_COLOR)

      LENGTH        = /[+-]?(?:#{NUMBER}(?:px|em|ex|in|cm|mm|pt|pc)|0)/ni
      URL           = /url\(#{WHITESPACE}*(?:#{STRING}|(?:[!\#$%&*-\[\]-~]|{NONASCII}|{ESCAPE})*)#{WHITESPACE}*\)/ni

      REPEAT        = /no-repeat|repeat(?:-[xy])?/ni
      X_POSITION    = /#{PERCENTAGE}|#{LENGTH}|left|center|right/ni
      Y_POSITION    = /#{PERCENTAGE}|#{LENGTH}|top|center|bottom/ni
      POSITION      = /#{X_POSITION}\s+#{Y_POSITION}|#{Y_POSITION}\s+#{X_POSITION}|#{X_POSITION}|#{Y_POSITION}|inherit/ni
      ATTACHMENT    = /scroll|fixed|inherit/ni
      BORDER_STYLE  = /none|hidden|dotted|dashed|solid|double|groove|ridge|inset|outset|inherit/ni
    end
  end
end
