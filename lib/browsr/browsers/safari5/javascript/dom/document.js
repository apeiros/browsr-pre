// This file is included by ../browsr.js
// Global is the global contexts object

var DocumentPrototype = Object.create({}, {
  adoptNode:                    {configurable: false, enumerable: true, value: function adoptNode() {}},
  caretRangeFromPoint:          {configurable: false, enumerable: true, value: function caretRangeFromPoint() {}},
  createAttribute:              {configurable: false, enumerable: true, value: function createAttribute() {}},
  createAttributeNS:            {configurable: false, enumerable: true, value: function createAttributeNS() {}},
  createCDATASection:           {configurable: false, enumerable: true, value: function createCDATASection() {}},
  createComment:                {configurable: false, enumerable: true, value: function createComment() {}},
  createDocumentFragment:       {configurable: false, enumerable: true, value: function createDocumentFragment() {}},
  createElement:                {configurable: false, enumerable: true, value: function createElement() {}},
  createElementNS:              {configurable: false, enumerable: true, value: function createElementNS() {}},
  createEntityReference:        {configurable: false, enumerable: true, value: function createEntityReference() {}},
  createEvent:                  {configurable: false, enumerable: true, value: function createEvent() {}},
  createExpression:             {configurable: false, enumerable: true, value: function createExpression() {}},
  createNSResolver:             {configurable: false, enumerable: true, value: function createNSResolver() {}},
  createNodeIterator:           {configurable: false, enumerable: true, value: function createNodeIterator() {}},
  createProcessingInstruction:  {configurable: false, enumerable: true, value: function createProcessingInstruction() {}},
  createRange:                  {configurable: false, enumerable: true, value: function createRange() {}},
  createTextNode:               {configurable: false, enumerable: true, value: function createTextNode() {}},
  createTreeWalker:             {configurable: false, enumerable: true, value: function createTreeWalker() {}},
  elementFromPoint:             {configurable: false, enumerable: true, value: function elementFromPoint() {}},
  evaluate:                     {configurable: false, enumerable: true, value: function evaluate() {}},
  execCommand:                  {configurable: false, enumerable: true, value: function execCommand() {}},
  getCSSCanvasContext:          {configurable: false, enumerable: true, value: function getCSSCanvasContext() {}},
  getElementById:               {configurable: false, enumerable: true, value: function getElementById() {}},
  getElementsByClassName:       {configurable: false, enumerable: true, value: function getElementsByClassName() {}},
  getElementsByName:            {configurable: false, enumerable: true, value: function getElementsByName() {}},
  getElementsByTagName:         {configurable: false, enumerable: true, value: function getElementsByTagName() {}},
  getElementsByTagNameNS:       {configurable: false, enumerable: true, value: function getElementsByTagNameNS() {}},
  getOverrideStyle:             {configurable: false, enumerable: true, value: function getOverrideStyle() {}},
  getSelection:                 {configurable: false, enumerable: true, value: function getSelection() {}},
  importNode:                   {configurable: false, enumerable: true, value: function importNode() {}},
  queryCommandEnabled:          {configurable: false, enumerable: true, value: function queryCommandEnabled() {}},
  queryCommandIndeterm:         {configurable: false, enumerable: true, value: function queryCommandIndeterm() {}},
  queryCommandState:            {configurable: false, enumerable: true, value: function queryCommandState() {}},
  queryCommandSupported:        {configurable: false, enumerable: true, value: function queryCommandSupported() {}},
  queryCommandValue:            {configurable: false, enumerable: true, value: function queryCommandValue() {}},
  querySelector:                {configurable: false, enumerable: true, value: function querySelector() {}},
  querySelectorAll:             {configurable: false, enumerable: true, value: function querySelectorAll() {}}
});

Object.defineProperty(Global, 'Document', {value: DocumentPrototype, configurable: false});
