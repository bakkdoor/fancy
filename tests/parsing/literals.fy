def require_relative: path {
  require((File expand_path(path, File dirname(__FILE__)) to_s))
}

require_relative: "../../boot/fancy.kpeg"

class String {
  def to_sexp {
    parser = Fancy KPEG new(self)
    parser parse()
    parser output()
  }
}

FancySpec describe: "Parse literals" for: (Fancy KPEG) with: {
  it: "parses literal integer" when: {
    "1"        to_sexp should == [[ 'int, 1 ]]
    "12"       to_sexp should == [[ 'int, 12 ]]
    "123"      to_sexp should == [[ 'int, 123 ]]
    "123_456"  to_sexp should == [[ 'int, 123456 ]]
    "+123_456" to_sexp should == [[ 'int, 123456 ]]
    "-123_456" to_sexp should == [[ 'int, -123456 ]]
  }

  it: "parses literal octal integer" when: {
    "0o1151265171444662" to_sexp should == [[ 'int, 42424242424242 ]]
    "0O1151265171444662" to_sexp should == [[ 'int, 42424242424242 ]]
  }

  it: "parses literal hexadecimal Integer" when: {
    "0x295860fdc7e1a34b" to_sexp should == [[ 'int, 2979237796602028875 ]]
    "0X295860fdc7e1a34b" to_sexp should == [[ 'int, 2979237796602028875 ]]
  }

  it: "parses literal binary Integer" when: {
    "0b101010" to_sexp should == [[ 'int, 42 ]]
    "0B101010" to_sexp should == [[ 'int, 42 ]]
  }

  it: "parses literal Float" when: {
    "1.2"           to_sexp should == [[ 'float, 1.2 ]]
    "12.3"          to_sexp should == [[ 'float, 12.3 ]]
    "12.34"         to_sexp should == [[ 'float, 12.34 ]]
    "123.456"       to_sexp should == [[ 'float, 123.456 ]]
    "123_456.789_0" to_sexp should == [[ 'float, 123456.789_0 ]]
    "+123.456"      to_sexp should == [[ 'float, 123.456 ]]
    "-123.456"      to_sexp should == [[ 'float, -123.456 ]]
  }

  it: "parses literal Symbol" when: {
    "'foo" to_sexp should == [['sym, 'foo]]
  }
}
