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
    space = /\s+/
    identifier = space && /(\S+)/ #&& (space optional)
    class_def = c && identifier ==> |_ classname| {
      ('class_def, classname[1] to_sym)
    }

    class_def parse: "class Foo" . is: ('class_def, 'Foo)
  }

  it: "parses optional rules" when: {
    opt = /a/ optional ==> {
      'yes
    }

    opt parse: "a" . is: 'yes
    opt parse: "" . is: 'yes
  }

  it: "parses ManyRule correctly" when: {
    many = /f/ min: 1 max: 2 ==> {
      'woot
    }

    # many parse: "" . is: nil
    # many parse: "a" . is: nil
    many parse: "af" . is: 'woot
    many parse: "f" . is: 'woot
    many parse: "ff" . is: 'woot
    # many parse: "fff" . is: nil
  }
}
