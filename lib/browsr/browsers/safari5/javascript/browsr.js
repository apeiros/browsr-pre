window    = null;
document  = null;

function DOMWindow() {
}
function Document() {
  this.prototype = new HTMLElement();
  this.location = {
    href:     __NATIVE__["javascript.document.location.href"],      // "http://127.0.0.1:80/index.html"
    protocol: __NATIVE__["javascript.document.location.protocol"],  // "http:",
    host:     __NATIVE__["javascript.document.location.host"],      // "127.0.0.1:80",
    hostname: __NATIVE__["javascript.document.location.hostname"],  // "127.0.0.1",
    port:     __NATIVE__["javascript.document.location.port"],      // "80",
    pathname: __NATIVE__["javascript.document.location.pathname"],  // "/index.html",
    hash:     __NATIVE__["javascript.document.location.hash"],      // "",
    search:   __NATIVE__["javascript.document.location.search"]     // ""
  }
}
function CSSStyleDeclaration() {
}

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

Document.prototype.defaultView function defaultView() {
  return window;
}
Document.prototype.getElementById = function getElementById(id) {}
Document.prototype.getElementsByClassName = function getElementsByClassName(className) {}
Document.prototype.getElementsByTagName = function getElementsByTagName(className) {}
Document.prototype.querySelector = function querySelector(selector) {}
Document.prototype.querySelectorAll = function querySelectorAll(selector) {}

CSSStyleDeclaration.prototype.getPropertyValue = function getPropertyValue(name) {
}
CSSStyleDeclaration.prototype.cssText = function cssText() {
}

window   = new DOMWindow();
document = new Document();