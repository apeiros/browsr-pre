// This file is included by ../browsr.js
// Global is the global contexts object

var NodePrototype = Object.create({}, {
  ELEMENT_NODE:                   {configurable: false, enumerable: true, value: 1},
  ATTRIBUTE_NODE:                 {configurable: false, enumerable: true, value: 2},
  TEXT_NODE:                      {configurable: false, enumerable: true, value: 3},
  CDATA_SECTION_NODE:             {configurable: false, enumerable: true, value: 4},
  ENTITY_REFERENCE_NODE:          {configurable: false, enumerable: true, value: 5},
  ENTITY_NODE:                    {configurable: false, enumerable: true, value: 6},
  PROCESSING_INSTRUCTION_NODE:    {configurable: false, enumerable: true, value: 7},
  COMMENT_NODE:                   {configurable: false, enumerable: true, value: 8},
  DOCUMENT_NODE:                  {configurable: false, enumerable: true, value: 9},
  DOCUMENT_TYPE_NODE:             {configurable: false, enumerable: true, value: 10},
  DOCUMENT_FRAGMENT_NODE:         {configurable: false, enumerable: true, value: 11},
  NOTATION_NODE:                  {configurable: false, enumerable: true, value: 12},
  addEventListener:               {configurable: false, enumerable: true, value: function addEventListener() {}},
  appendChild:                    {configurable: false, enumerable: true, value: function appendChild() {}},
  cloneNode:                      {configurable: false, enumerable: true, value: function cloneNode() {}},
  compareDocumentPosition:        {configurable: false, enumerable: true, value: function compareDocumentPosition() {}},
  dispatchEvent:                  {configurable: false, enumerable: true, value: function dispatchEvent() {}},
  hasAttributes:                  {configurable: false, enumerable: true, value: function hasAttributes() {}},
  hasChildNodes:                  {configurable: false, enumerable: true, value: function hasChildNodes() {}},
  insertBefore:                   {configurable: false, enumerable: true, value: function insertBefore() {}},
  isDefaultNamespace:             {configurable: false, enumerable: true, value: function isDefaultNamespace() {}},
  isEqualNode:                    {configurable: false, enumerable: true, value: function isEqualNode() {}},
  isSameNode:                     {configurable: false, enumerable: true, value: function isSameNode() {}},
  isSupported:                    {configurable: false, enumerable: true, value: function isSupported() {}},
  lookupNamespaceURI:             {configurable: false, enumerable: true, value: function lookupNamespaceURI() {}},
  lookupPrefix:                   {configurable: false, enumerable: true, value: function lookupPrefix() {}},
  normalize:                      {configurable: false, enumerable: true, value: function normalize() {}},
  removeChild:                    {configurable: false, enumerable: true, value: function removeChild() {}},
  removeEventListener:            {configurable: false, enumerable: true, value: function removeEventListener() {}},
  replaceChild:                   {configurable: false, enumerable: true, value: function replaceChild() {}}
});

Object.defineProperty(Global, 'Node', {value: NodePrototype, configurable: false});
