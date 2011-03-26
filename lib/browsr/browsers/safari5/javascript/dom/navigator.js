// This file is included by ../browsr.js
// Global is the global contexts object

var NavigatorPrototype = Object.create({}, {
  getStorageUpdates:        {configurable: false, enumerable: true, get: function getStorageUpdates() { return null; }},
  javaEnabled:              {configurable: false, enumerable: true, get: function javaEnabled() { return null; }},
  registerContentHandler:   {configurable: false, enumerable: true, get: function registerContentHandler() { return null; }},
  registerProtocolHandler:  {configurable: false, enumerable: true, get: function registerProtocolHandler() { return null; }}
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
