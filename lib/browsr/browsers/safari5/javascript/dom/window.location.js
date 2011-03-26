// This file is included by ../browsr.js
// Global is the global contexts object

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

