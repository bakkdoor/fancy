class Outer {
  class Inner {
    def to_s {
      "Outerr::Inner"
    }
  }

  def to_s {
    "Outer"
  }
}


o = Outer new
o println
i = Outer::Inner new
i println

class Outer InnerTwo {
  def to_s { "Outer::InnerTwo" }
}

i = Outer InnerTwo new
i println

