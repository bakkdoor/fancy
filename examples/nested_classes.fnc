def class Outer {
  def class Inner {
    def to_s {
      "Outerr::Inner"
    }
  }

  def to_s {
    "Outer"
  }
};

o = Outer new;
o println;
i = Outer::Inner new;
i println
