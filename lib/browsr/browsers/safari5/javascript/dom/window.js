// This file is included by ../browsr.js
// Global is the global contexts object

Object.defineProperty(Global, 'window', {value: Global, configurable: false});
Object.defineProperties(Global.window, {
  location: {
    get: function() { return Location; },
    set: function() { throw("Unimplemented"); },
    configurable: false
  }
});
