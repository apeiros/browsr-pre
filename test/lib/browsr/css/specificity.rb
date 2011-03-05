test "specificity" do
  [
     '*',                '0,0,0,0',
     'li',               '0,0,0,1',
     'li:first-line',    '0,0,0,2',
     'ul li',            '0,0,0,2',
     'ul ol+li',         '0,0,0,3',
     'h1 + *[rel=up]',   '0,0,1,1',
     'ul ol li.red',     '0,0,1,3',
     'li.red.level',     '0,0,2,1',
     '#x34y',            '0,1,0,0',
  ].each_slice(2) do |selector, should_be|
    p Browsr::CSS::Specificity.parse(selector) => should_be
  end
end