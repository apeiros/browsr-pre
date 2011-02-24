function Foo(bar) {
  this.bar = bar;
}
Foo.prototype.getBar = function getBar() {
  return this.bar;
}
Foo.prototype.setBar = function setBar(value) {
  this.bar = value;
}
