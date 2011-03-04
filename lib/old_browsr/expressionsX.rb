class Browsr
  class CSS
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
      NOT             = /:#{N}#{O}#{T}\(/n
      ATKEYWORD       = /@{Ident}/n
      INVALID         = /{Invalid}/n
      PERCENTAGE      = /{Num}%/n
      DIMENSION       = /{Num}{Ident}/n
      CDO             = /<!--/n
      CDC             = /-->/n
  
      ElementName             = Ident
      NamespacePrefix         = /(?:#{Ident}|\*)|\|/n
      Klass                   = /\.#{Ident}/n
      Universal               = /#{NamespacePrefix}?\*/n
      TypeSelector            = /#{NamespacePrefix}?#{ElementName}/n
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
      FunctionalPseudo        = /#{FUNCTION}#{Whitespace}*#{Expression}\)/n
      Pseudo                  = /::?(?:#{Ident}|#{FunctionalPseudo})/n
      NegationArg             = /#{TypeSelector}|#{Universal}|\#|#{Klass}|#{Attrib}|#{Pseudo}/n
      Negation                = /#{NOT}#{Whitespace}*#{NegationArg}#{Whitespace}*/n
      Combinator              = /[\+>~]#{Whitespace}*|#{Whitespace}+/n
      SimpleSelectorSequence  = /(?:(?:#{TypeSelector}|#{Universal})(?:\#|#{Klass}|#{Attrib}|#{Pseudo}|#{Negation})*)|(?:\#|#{Klass}|#{Attrib}|#{Pseudo}|#{Negation})+/n
      Selector                = /#{SimpleSelectorSequence}(?:#{Combinator}#{SimpleSelectorSequence})*/n
      SelectorsGroup          = /#{Selector}(?:,#{Whitespace}*#{Selector})*/n
      Expression              = /(?:(?:[+-]|#{DIMENSION}|#{NUMBER}|#{String}|#{Ident})#{Whitespace}*)+/n
    end
  end
end
