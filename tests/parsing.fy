require: "lib/parsing"

FancySpec describe: Parsing with: {
  metaclass include: Parsing

  it: "parses a text correctly" when: {
    rule = /hello, (.*)/ ==> |_ greeted| {
      greeted
    }

    rule2 = /^hello(.*)$/ ==> |v _| {
      v
    }

    rule3 = /^hello/ ==> {
      42
    }

    rule parse: "hello, world!" . is: "world!"
    rule2 parse: "hello, world2!" . is: "hello, world2!"
    rule3 parse: "hello, world3!" . is: 42
  }

  it: "creates a simple ast" when: {
    c = /class/
    class_def = c && /\s+(\S+)/ ==> |_ classname| {
      ('class_def, classname[1] to_sym)
    }
    class_def parse: "class Foo" . is: ('class_def, 'Foo)
  }
}
