class Browsr
  module Javascript
    R_TagName   = /\A[A-Za-z_][A-Za-z0-9_-]*\z/
    R_ClassName = /\A[A-Za-z_][A-Za-z0-9_]*\z/
    R_AttrID    = /\A[A-Za-z_][A-Za-z0-9_]*\z/

    class JSObject
      def self.not_yet_implemented(*args)
        args.each do |name|
          define_method name do raise "#{name} is not yet implemented" end
        end
      end
    end

    class Context < JSObject
      def initialize(browsr, browsr_window)
        @browsr        = browsr
        @browsr_window = browsr_window
        @html_window   = HTMLWindow.new(browsr_window, self)
      end

      def window
        @html_window
      end

      def document
        @html_window.document
      end
    end
    
    class CSSStyleDeclaration < JSObject
      def initialize(properties)
        @properties = properties
      end

      def getPropertyValue(name)
        @properties[name]
      end

      def cssText
        @properties.to_css
      end
    end

    class HTMLWindow < JSObject
      def initialize(browsr_window, js_context)
        @browsr_window = browsr_window
        @js_context    = js_context
      end

      def document
        @document ||= HTMLDocument.new(@browsr_window, @js_context)
      end

      # FIXME: broken
      # * get order right (origin, specificity, important)
      # * get merging right (break up shorthands before merge)
      # * consider style tag
      # * handle 'inherited'
      # * handle property defaults
      def getComputedStyle(html_element, pseudoElt=nil)
        node    = html_element.instance_variable_get(:@node)
        pseudo  = Browsr::CSS::Pseudo.new
        matches = @browsr_window.styles.rules.select { |rule|
          @browsr_window.dom.css(rule.selector, pseudo).include?(node)
        }
        properties_hash = matches.inject({}) { |m,r|
          m.merge(r.properties.to_hash)
        }

        CSSStyleDeclaration.new(Browsr::CSS::Properties.new(properties_hash))
      end
    end

    class HTMLElement < JSObject
      # I *suspect* that some of those below are actually only on HTMLDocument, not on HTMLElement
      not_yet_implemented :bgColor, :text, :background, :aLink, :vLink, :link, :outerHTML, :className, :innerText, :id,
                          :title, :lang, :dir, :contentEditable, :tabIndex, :draggable, :outerText, :children, :isContentEditable,
                          :style, :scrollLeft, :clientWidth, :firstElementChild, :scrollWidth, :clientLeft, :offsetWidth, :offsetLeft,
                          :clientTop, :lastElementChild, :offsetParent, :nextElementSibling, :previousElementSibling, :clientHeight,
                          :childElementCount, :offsetTop, :offsetHeight, :scrollTop, :scrollHeight, :previousSibling, :parentNode,
                          :lastChild, :baseURI, :firstChild, :nodeValue, :textContent, :nodeType, :nodeName, :prefix, :childNodes,
                          :nextSibling, :attributes, :ownerDocument, :namespaceURI, :localName, :parentElement

      def initialize(browsr_window, js_context, node)
        @browsr_window = browsr_window
        @js_context    = js_context
        @node          = node
      end

      def innerHTML=(value)
        @node.inner_html = value.to_s
      end

      def innerHTML
        @node.inner_html
      end

      def innerText=(value)
        @node.inner_html = value.to_s
      end

      def innerText
        @node.inner_text
      end

      def tagName
        @node.name.upcase
      end

      def getAttribute(name)
        @node[name]
      end

      def setAttribute(name, value)
        @node[name] = value
      end

      def to_s
        attrs = @node.attributes.empty? ? "" : " #{@node.attributes.map { |name,a| "#{name}=#{a.value.inspect}" }.join(" ")}"
        "[HTMLElement <#{@node.name}#{attrs}>]"
      end
    end

    class HTMLDocument < HTMLElement
      def initialize(browsr_window, js_context)
        super(browsr_window, js_context, browsr_window.dom.at_css('body'))
      end

      def defaultView
        @js_context.window
      end

      def getElementById(id)
        id = id.to_s
        return unless id =~ R_AttrID
        node = @browsr_window.dom.at_css("\##{id}")
        node && HTMLElement.new(@browsr_window, @js_context, node)
      end

      def getElementsByClassName(class_name)
        class_name = class_name.to_s
        return unless class_name =~ R_ClassName
        node = @browsr_window.dom.css(class_name)
        node && HTMLElement.new(@browsr_window, @js_context, node)
      end

      def getElementsByTagName(tag_name)
        tag_name = tag_name.to_s
        return unless tag_name =~ R_TagName
        node = @browsr_window.dom.css(tag_name)
        node && HTMLElement.new(@browsr_window, @js_context, node)
      end

      def querySelector(selector)
        node = @browsr_window.dom.at_css(selector.to_s)
        node && HTMLElement.new(@browsr_window, @js_context, node)
      end

      def querySelectorAll(selector)
        @browsr_window.dom.css(selector.to_s).map { |node|
          HTMLElement.new(@browsr_window, @js_context, node)
        }
      end
    end
  end
end
