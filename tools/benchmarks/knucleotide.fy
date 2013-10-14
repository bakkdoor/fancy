
def frequency: seq keys: keys {
  counts = Hash new: 0
  keys each: |key| {
    last_index = 0
    while: { last_index = seq index(key, last_index + 1) } do: {
      counts at: key put: (counts[key] + 1)
    }
  }
  return counts
}
def percentage: seq keys: keys {
  frequency: seq keys: keys . sort: |a, b| { b1 = b[1]; a1 = a[1]; b1 <=> a1 } . map: |key, value| {
    "%s %.3f" %([
      key upcase,
      ((value * 100) to_f) / (seq size)
    ])
  }
}

def count: seq keys: keys {
  frequency: seq keys: keys . map: |key, value| {
    "#{value to_s}\t#{key upcase}"
  }
}
_, seq = STDIN read scan(/(\n>THREE[^\n]*\n)([^>]*)\n/) flatten
seq force_encoding("ASCII-8BIT")
seq gsub!(/\s/, "")

singles = ["a", "t", "c", "g"]
doubles = singles map: |a| { singles map: |b| { "#{a}#{b}" } } . flatten
chains  = ["ggt", "ggta", "ggtatt", "ggtattttaatt", "ggtattttaatttatagt"]

percentage: seq keys: singles . join: "\n" . println
"\n\n" println
percentage: seq keys: doubles . join: "\n" . println
"\n\n" println
count: seq keys: chains . join: "\n" . println
"\n" println
