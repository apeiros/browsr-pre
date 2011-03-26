/* globals */
window    = null;
document  = null;

(function(Global) {
  /* constructors */
  Global.DOMWindow = function DOMWindow() {
  }
  Global.HTMLElement = function HTMLElement() {
  }

  var $Location
  Global.Location = function Location() {
  }
  function Document() {
  }
  function CSSStyleDeclaration() {
    this.item     = null;
    this.readOnly = false;
  }



  /* local utility functions - protected through closure */
  function extractFromNokogiri(node) {
    {
      tagName: node.name.toUpperCase(),
      attributes: {
  }


  CSSStyleDeclaration.prototype.__defineSetter__('cssText', function(value) {
    if (this.readOnly) throw("NO_MODIFICATION_ALLOWED_ERR");
    
  });
  
  // Returns the optional priority, "important".
  // Example: priString= styleObj.getPropertyPriority('color')
  CSSStyleDeclaration.prototype.getPropertyPriority = function getPropertyPriority(propertyName) {
  }
  
  // Returns the property value.
  // Example: valString= styleObj.getPropertyValue('color')
  CSSStyleDeclaration.prototype.getPropertyValue = function getPropertyValue(propertyName) {
  }
  
  // item[index]
  // Returns a property name.
  // Example: nameString= styleObj.item[0]
  // Alternative: nameString= styleObj[0]
  
  // Returns the value deleted.
  // Example: valString= styleObj.removeProperty('color')
  CSSStyleDeclaration.prototype.removeProperty = function removeProperty(propertyName) {
  }
  
  // No return.
  // Example: styleObj.setProperty('color', 'red', 'important')
  CSSStyleDeclaration.prototype.setProperty = function setProperty(propertyName, value, priority) {
  }
  
  CSSStyleDeclaration.prototype.getPropertyCSSValue = function getPropertyCSSValue(propertyName) {
  }
  Location.prototype.__defineGetter__('href', function() {
    return __NATIVE__["javascript.document.location.href"];      // "http://127.0.0.1:80/index.html"
    protocol: __NATIVE__["javascript.document.location.protocol"],  // "http:",
    host:     __NATIVE__["javascript.document.location.host"],      // "127.0.0.1:80",
    hostname: __NATIVE__["javascript.document.location.hostname"],  // "127.0.0.1",
    port:     __NATIVE__["javascript.document.location.port"],      // "80",
    pathname: __NATIVE__["javascript.document.location.pathname"],  // "/index.html",
    hash:     __NATIVE__["javascript.document.location.hash"],      // "",
    search:   __NATIVE__["javascript.document.location.search"]     // ""
  });
  
  HTMLElement.prototype.__defineSetter__('innerHTML', function(value) {
  })
  HTMLElement.prototype.__defineGetter__('innerHTML', function() {
  })
  HTMLElement.prototype.__defineSetter__('innerText', function(value) {
  })
  HTMLElement.prototype.__defineGetter__('innerText', function() {
  })
  HTMLElement.prototype.__defineGetter__('tagName', function() {
  })
  HTMLElement.prototype.getAttribute = function getAttribute(name) {
  }
  HTMLElement.prototype.setAttribute = function setAttribute(name, value) {
  }
  
  DOMWindow.prototype.document = function document() {
    return document;
  }
  DOMWindow.prototype.getComputedStyle = function getComputedStyle(htmlElement, pseudoElt) {
    return new CSSStyleDeclaration();
  }

  /* Document */
  Document.prototype = new HTMLElement();
  Document.prototype.defaultView = function defaultView() {
    return window;
  }
  Document.prototype.getElementById = function getElementById(id) {
    return __NATIVE__["dom.at_css"]("\##{id}");
  }
  Document.prototype.getElementsByClassName = function getElementsByClassName(className) {
    var nativeNode = __NATIVE__["dom.at_css"](".#{className}");
    var nodeData   = extractFromNokogiri(nativeNode);

    return new HTMLElement(nodeData);
    //switch(nodeData) {
    //
    //}
  }
  Document.prototype.getElementsByTagName = function getElementsByTagName(className) {}
  Document.prototype.querySelector = function querySelector(selector) {}
  Document.prototype.querySelectorAll = function querySelectorAll(selector) {}
  
  CSSStyleDeclaration.prototype.getPropertyValue = function getPropertyValue(name) {
  }
  CSSStyleDeclaration.prototype.cssText = function cssText() {
  }
})(this);

window   = new DOMWindow();
document = new Document();
