# package: Fancy::Collections

def class Array {
  def map: block {
    coll = [];
    self each: |x| {
      coll << (block call: [x])
    }
  }
}
