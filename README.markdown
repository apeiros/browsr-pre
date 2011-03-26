GETTING STARTED
===============

    gem install mime-types
    gem install nokogiri
    gem install therubyracer

    cd PROJECTDIR
    cd example
    irb -r ./test.rb
    ruby-1.9.2-p136 | irb:001:0> B
    => #<Browsr>
    ruby-1.9.2-p136 | irb:002:0> window = B.visit 'http://127.0.0.1:3000/index.html'
    => #<Browsr::Window /index.html>
    ruby-1.9.2-p136 | irb:003:0> window.eval_js 'x = new Foo("the value"); x.bar'
    => "the value"
    ruby-1.9.2-p136 | irb:004:0> puts window.css.computed_style_for_nokogiri(window.dom, window.dom.at_css('h1')).to_css
    color: red; background-color: yellow; border-left-style: solid; border-left-color: black; border-left-width: 1px;
    => nil
