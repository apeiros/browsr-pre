// This file is included by ../browsr.js
// Global is the global contexts object

var HTMLElement = Object.create({}, {
  blur:                       {configurable: false, enumerable: true, value: function blur() {}},
  contains:                   {configurable: false, enumerable: true, value: function contains() {}},
  focus:                      {configurable: false, enumerable: true, value: function focus() {}},
  getAttribute:               {configurable: false, enumerable: true, value: function getAttribute() {}},
  getAttributeNS:             {configurable: false, enumerable: true, value: function getAttributeNS() {}},
  getAttributeNode:           {configurable: false, enumerable: true, value: function getAttributeNode() {}},
  getAttributeNodeNS:         {configurable: false, enumerable: true, value: function getAttributeNodeNS() {}},
  getBoundingClientRect:      {configurable: false, enumerable: true, value: function getBoundingClientRect() {}},
  getClientRects:             {configurable: false, enumerable: true, value: function getClientRects() {}},
  getElementsByClassName:     {configurable: false, enumerable: true, value: function getElementsByClassName() {}},
  getElementsByTagName:       {configurable: false, enumerable: true, value: function getElementsByTagName() {}},
  getElementsByTagNameNS:     {configurable: false, enumerable: true, value: function getElementsByTagNameNS() {}},
  hasAttribute:               {configurable: false, enumerable: true, value: function hasAttribute() {}},
  hasAttributeNS:             {configurable: false, enumerable: true, value: function hasAttributeNS() {}},
  querySelector:              {configurable: false, enumerable: true, value: function querySelector() {}},
  querySelectorAll:           {configurable: false, enumerable: true, value: function querySelectorAll() {}},
  removeAttribute:            {configurable: false, enumerable: true, value: function removeAttribute() {}},
  removeAttributeNS:          {configurable: false, enumerable: true, value: function removeAttributeNS() {}},
  removeAttributeNode:        {configurable: false, enumerable: true, value: function removeAttributeNode() {}},
  scrollByLines:              {configurable: false, enumerable: true, value: function scrollByLines() {}},
  scrollByPages:              {configurable: false, enumerable: true, value: function scrollByPages() {}},
  scrollIntoView:             {configurable: false, enumerable: true, value: function scrollIntoView() {}},
  scrollIntoViewIfNeeded:     {configurable: false, enumerable: true, value: function scrollIntoViewIfNeeded() {}},
  setAttribute:               {configurable: false, enumerable: true, value: function setAttribute() {}},
  setAttributeNS:             {configurable: false, enumerable: true, value: function setAttributeNS() {}},
  setAttributeNode:           {configurable: false, enumerable: true, value: function setAttributeNode() {}},
  setAttributeNodeNS:         {configurable: false, enumerable: true, value: function setAttributeNodeNS() {}}
});

Object.defineProperty(Global, 'HTMLElement', {value: HTMLElement, configurable: false});
