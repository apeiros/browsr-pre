(function(Global) {
  // From: dom/window.location.js
  Location = Object.create({}, {
    href: {
      get: function() {
        return __NATIVE__["javascript.document.location.href"]; // "http://127.0.0.1:80/index.html"
      },
      set: function() {
        throw("Unimplemented");
      }
    }
  });



  // From: dom/window.js
  Object.defineProperty(Global, 'window', {value: Global, configurable: false});
  Object.defineProperties(Global.window, {
    location: {
      get: function() { return Location; },
      set: function() { throw("Unimplemented"); },
      configurable: false
    }
  });



  // From: dom/navigator.js
  var NavigatorPrototype = Object.create({}, {
    getStorageUpdates:    {configurable: false, enumerable: true, get: function() { return null; }},
    javaEnabled:          {configurable: false, enumerable: true, get: function() { return null; }}
  });
  
  var navigator = Object.create(NavigatorPrototype, {
    appCodeName:          {configurable: false, enumerable: true, get: function() { return __NATIVE__["javascript.window.navigator.appCodeName"]; }},
    appName:              {configurable: false, enumerable: true, get: function() { return __NATIVE__["javascript.window.navigator.appName"]; }},
    appVersion:           {configurable: false, enumerable: true, get: function() { return __NATIVE__["javascript.window.navigator.appVersion"]; }},
    cookieEnabled:        {configurable: false, enumerable: true, get: function() { return __NATIVE__["javascript.window.navigator.cookieEnabled"]; }},
    geolocation:          {configurable: false, enumerable: true, get: function() { return __NATIVE__["javascript.window.navigator.geolocation"]; }},
    language:             {configurable: false, enumerable: true, get: function() { return __NATIVE__["javascript.window.navigator.language"]; }},
    mimeTypes:            {configurable: false, enumerable: true, get: function() { return __NATIVE__["javascript.window.navigator.mimeTypes"]; }},
    onLine:               {configurable: false, enumerable: true, get: function() { return __NATIVE__["javascript.window.navigator.onLine"]; }},
    platform:             {configurable: false, enumerable: true, get: function() { return __NATIVE__["javascript.window.navigator.platform"]; }},
    plugins:              {configurable: false, enumerable: true, get: function() { return __NATIVE__["javascript.window.navigator.plugins"]; }},
    product:              {configurable: false, enumerable: true, get: function() { return __NATIVE__["javascript.window.navigator.product"]; }},
    productSub:           {configurable: false, enumerable: true, get: function() { return __NATIVE__["javascript.window.navigator.productSub"]; }},
    userAgent:            {configurable: false, enumerable: true, get: function() { return __NATIVE__["javascript.window.navigator.userAgent"]; }},
    vendor:               {configurable: false, enumerable: true, get: function() { return __NATIVE__["javascript.window.navigator.vendor"]; }},
    vendorSub:            {configurable: false, enumerable: true, get: function() { return __NATIVE__["javascript.window.navigator.vendorSub"]; }}
  });
  
  Object.defineProperty(Global, 'navigator', {value: navigator, configurable: false});



  // From: dom/node.js
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



  // From: dom/document.js
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



  // From: dom/htmldocument.js
  var HTMLDocumentPrototype = Object.create(DocumentPrototype, {
    captureEvents:            {configurable: false, enumerable: true, value: function captureEvents() {}},
    clear:                    {configurable: false, enumerable: true, value: function clear() {}},
    close:                    {configurable: false, enumerable: true, value: function close() {}},
    hasFocus:                 {configurable: false, enumerable: true, value: function hasFocus() {}},
    open:                     {configurable: false, enumerable: true, value: function open() {}},
    releaseEvents:            {configurable: false, enumerable: true, value: function releaseEvents() {}},
    write:                    {configurable: false, enumerable: true, value: function write() {}},
    writeln:                  {configurable: false, enumerable: true, value: function writeln() {}}
  });
  
  var document = Object.create(HTMLDocumentPrototype, {
    URL:                      {configurable: false, enumerable: true, value: null},
    activeElement:            {configurable: false, enumerable: true, value: null},
    alinkColor:               {configurable: false, enumerable: true, value: null},
    all:                      {configurable: false, enumerable: true, value: null},
    anchors:                  {configurable: false, enumerable: true, value: null},
    applets:                  {configurable: false, enumerable: true, value: null},
    attributes:               {configurable: false, enumerable: true, value: null},
    baseURI:                  {configurable: false, enumerable: true, value: null},
    bgColor:                  {configurable: false, enumerable: true, value: null},
    body:                     {configurable: false, enumerable: true, value: null},
    characterSet:             {configurable: false, enumerable: true, value: null},
    charset:                  {configurable: false, enumerable: true, value: null},
    childNodes:               {configurable: false, enumerable: true, value: null},
    compatMode:               {configurable: false, enumerable: true, value: null},
    constructor:              {configurable: false, enumerable: true, value: null},
    cookie:                   {configurable: false, enumerable: true, value: null},
    defaultCharset:           {configurable: false, enumerable: true, value: null},
    defaultView:              {configurable: false, enumerable: true, value: null},
    designMode:               {configurable: false, enumerable: true, value: null},
    dir:                      {configurable: false, enumerable: true, value: null},
    doctype:                  {configurable: false, enumerable: true, value: null},
    documentElement:          {configurable: false, enumerable: true, value: null},
    documentURI:              {configurable: false, enumerable: true, value: null},
    domain:                   {configurable: false, enumerable: true, value: null},
    embeds:                   {configurable: false, enumerable: true, value: null},
    fgColor:                  {configurable: false, enumerable: true, value: null},
    firstChild:               {configurable: false, enumerable: true, value: null},
    forms:                    {configurable: false, enumerable: true, value: null},
    head:                     {configurable: false, enumerable: true, value: null},
    height:                   {configurable: false, enumerable: true, value: null},
    images:                   {configurable: false, enumerable: true, value: null},
    implementation:           {configurable: false, enumerable: true, value: null},
    inputEncoding:            {configurable: false, enumerable: true, value: null},
    lastChild:                {configurable: false, enumerable: true, value: null},
    lastModified:             {configurable: false, enumerable: true, value: null},
    linkColor:                {configurable: false, enumerable: true, value: null},
    links:                    {configurable: false, enumerable: true, value: null},
    localName:                {configurable: false, enumerable: true, value: null},
    location:                 {configurable: false, enumerable: true, value: null},
    namespaceURI:             {configurable: false, enumerable: true, value: null},
    nextSibling:              {configurable: false, enumerable: true, value: null},
    nodeName:                 {configurable: false, enumerable: true, value: null},
    nodeType:                 {configurable: false, enumerable: true, value: null},
    nodeValue:                {configurable: false, enumerable: true, value: null},
    onabort:                  {configurable: false, enumerable: true, value: null},
    onbeforecopy:             {configurable: false, enumerable: true, value: null},
    onbeforecut:              {configurable: false, enumerable: true, value: null},
    onbeforepaste:            {configurable: false, enumerable: true, value: null},
    onblur:                   {configurable: false, enumerable: true, value: null},
    onchange:                 {configurable: false, enumerable: true, value: null},
    onclick:                  {configurable: false, enumerable: true, value: null},
    oncontextmenu:            {configurable: false, enumerable: true, value: null},
    oncopy:                   {configurable: false, enumerable: true, value: null},
    oncut:                    {configurable: false, enumerable: true, value: null},
    ondblclick:               {configurable: false, enumerable: true, value: null},
    ondrag:                   {configurable: false, enumerable: true, value: null},
    ondragend:                {configurable: false, enumerable: true, value: null},
    ondragenter:              {configurable: false, enumerable: true, value: null},
    ondragleave:              {configurable: false, enumerable: true, value: null},
    ondragover:               {configurable: false, enumerable: true, value: null},
    ondragstart:              {configurable: false, enumerable: true, value: null},
    ondrop:                   {configurable: false, enumerable: true, value: null},
    onerror:                  {configurable: false, enumerable: true, value: null},
    onfocus:                  {configurable: false, enumerable: true, value: null},
    oninput:                  {configurable: false, enumerable: true, value: null},
    oninvalid:                {configurable: false, enumerable: true, value: null},
    onkeydown:                {configurable: false, enumerable: true, value: null},
    onkeypress:               {configurable: false, enumerable: true, value: null},
    onkeyup:                  {configurable: false, enumerable: true, value: null},
    onload:                   {configurable: false, enumerable: true, value: null},
    onmousedown:              {configurable: false, enumerable: true, value: null},
    onmousemove:              {configurable: false, enumerable: true, value: null},
    onmouseout:               {configurable: false, enumerable: true, value: null},
    onmouseover:              {configurable: false, enumerable: true, value: null},
    onmouseup:                {configurable: false, enumerable: true, value: null},
    onmousewheel:             {configurable: false, enumerable: true, value: null},
    onpaste:                  {configurable: false, enumerable: true, value: null},
    onreset:                  {configurable: false, enumerable: true, value: null},
    onscroll:                 {configurable: false, enumerable: true, value: null},
    onsearch:                 {configurable: false, enumerable: true, value: null},
    onselect:                 {configurable: false, enumerable: true, value: null},
    onselectstart:            {configurable: false, enumerable: true, value: null},
    onsubmit:                 {configurable: false, enumerable: true, value: null},
    ownerDocument:            {configurable: false, enumerable: true, value: null},
    parentElement:            {configurable: false, enumerable: true, value: null},
    parentNode:               {configurable: false, enumerable: true, value: null},
    plugins:                  {configurable: false, enumerable: true, value: null},
    preferredStylesheetSet:   {configurable: false, enumerable: true, value: null},
    prefix:                   {configurable: false, enumerable: true, value: null},
    previousSibling:          {configurable: false, enumerable: true, value: null},
    readyState:               {configurable: false, enumerable: true, value: null},
    referrer:                 {configurable: false, enumerable: true, value: null},
    scripts:                  {configurable: false, enumerable: true, value: null},
    selectedStylesheetSet:    {configurable: false, enumerable: true, value: null},
    styleSheets:              {configurable: false, enumerable: true, value: null},
    textContent:              {configurable: false, enumerable: true, value: null},
    title:                    {configurable: false, enumerable: true, value: null},
    vlinkColor:               {configurable: false, enumerable: true, value: null},
    width:                    {configurable: false, enumerable: true, value: null},
    xmlEncoding:              {configurable: false, enumerable: true, value: null},
    xmlStandalone:            {configurable: false, enumerable: true, value: null},
    xmlVersion:               {configurable: false, enumerable: true, value: null}
  });
  
  Object.defineProperty(Global, 'document', {value: document, configurable: false});



  // xINCLUDE dom/htmlelement.js
})(this);

