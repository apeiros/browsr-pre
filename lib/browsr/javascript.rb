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
      def initialize(browsr_window)
        @browsr_window = browsr_window
        @html_window   = HTMLWindow.new(browsr_window)
      end

      def window
        @html_window
      end

      def document
        @html_window.document
      end
    end

    class HTMLWindow < JSObject
      def initialize(window)
        @window = window
      end

      def document
        @document ||= HTMLDocument.new(@window)
      end
    end

    class HTMLDocument < JSObject
      def initialize(window)
        @window = window
      end

      def getElementById(id)
        id = id.to_s
        return unless id =~ R_AttrID
        node = @window.dom.at_css("\##{id}")
        node && HTMLElement.new(@window, node)
      end

      def getElementsByClassName(class_name)
        class_name = class_name.to_s
        return unless class_name =~ R_ClassName
        node = @window.dom.css(class_name)
        node && HTMLElement.new(@window, node)
      end

      def getElementsByTagName(tag_name)
        tag_name = tag_name.to_s
        return unless tag_name =~ R_TagName
        node = @window.dom.css(tag_name)
        node && HTMLElement.new(@window, node)
      end

      def querySelector(selector)
        node = @window.dom.at_css(selector.to_s)
        node && HTMLElement.new(@window, node)
      end

      def querySelectorAll(selector)
        @window.dom.css(selector.to_s).map { |node|
          HTMLElement.new(@window, node)
        }
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

      def initialize(window, node)
        @window = window
        @node   = node
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
  end
end
