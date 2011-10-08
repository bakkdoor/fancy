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
    space = /\s+/
    identifier = space & /(\S+)/ #& (space optional)
    class_def = "class" & identifier ==> |_ classname| {
      ('class_def, classname[1] to_sym)
    }

    class_def parse: "class Foo" . is: ('class_def, 'Foo)
  }

  it: "parses optional rules" when: {
    opt = "a" optional ==> {
      'yes
    }

    opt parse: "a" . is: 'yes
    opt parse: "" . is: 'yes
  }

  it: "parses min/max rules with [] operator" when: {
    rule = /f/ [[0,1]]
    rule min is: 0
    rule max is: 1
    rule is_a?: Parsing ManyRule . is: true
  }

  it: "parses ManyRule correctly" when: {
    many = /f/ [[1, 2]] ==> {
      'woot
    }

    many parse: "" . is: nil
    many parse: "a" . is: nil
    # many parse: "af" . is: 'woot
    # many parse: "f" . is: 'woot
    # many parse: "ff" . is: 'woot
    # many parse: "fff" . is: nil
  }

  it: "parses NotRule" when: {
    r = /f/ not ==> {
      'no_f
    }

    r parse: "" . is: 'no_f
    r parse: "a" . is: 'no_f
    r parse: "f" . is: false
    r parse: "af" . is: false
  }
}
