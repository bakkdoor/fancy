require("stringio")

WIDTH = 60
Last = 42; A = 3877; C = 29573; M = 139968

def rand: max {
  Last = (Last * A + C) % M
  return ((max * Last) / M)
}
ALU = "GGCCGGGCGCGGTGGCTCACGCCTGTAATCCCAGCACTTTGG" + \
      "GAGGCCGAGGCGGGCGGATCACCTGAGGTCAGGAGTTCGAGA" + \
      "CCAGCCTGGCCAACATGGTGAAACCCCGTCTCTACTAAAAAT" + \
      "ACAAAAATTAGCCGGGCGTGGTGGCGCGCGCCTGTAATCCCA" + \
      "GCTACTCGGGAGGCTGAGGCAGGAGAATCGCTTGAACCCGGG" + \
      "AGGCGGAGGTTGCAGTGAGCCGAGATCGCGCCACTGCACTCC" + \
      "AGCCTGGGCGACAGAGCGAGACTCCGTCTCAAAAA"

class AA {
  # TODO: Read-write slots are less performant than manual definition (see
  #       below for manual definition). Profile of read-write behavior is in
  #       fasta-perf-read-write-profile.txt
  # read_write_slots: ['c, 'p]
  def initialize: tuple {
    @c = tuple[0]; @p = tuple[1]
  }
  def c { @c }
  def p { @p }
  def c: c { @c = c }
  def p: p { @p = p }
}

IUB = [
  AA new: ("a", 0.27),
  AA new: ("c", 0.12),
  AA new: ("g", 0.12),
  AA new: ("t", 0.27),
  AA new: ("B", 0.02),
  AA new: ("D", 0.02),
  AA new: ("H", 0.02),
  AA new: ("K", 0.02),
  AA new: ("M", 0.02),
  AA new: ("N", 0.02),
  AA new: ("R", 0.02),
  AA new: ("S", 0.02),
  AA new: ("V", 0.02),
  AA new: ("W", 0.02),
  AA new: ("Y", 0.02)
]

HomoSap = [
  AA new: ("a", 0.3029549426680),
  AA new: ("c", 0.1979883004921),
  AA new: ("g", 0.1975473066391),
  AA new: ("t", 0.3015094502008)
]

def make_cumulative: list {
  cp = 0.0
  i = 0
  l = list length
  while: { i < l } do: {
    item = list[i]
    cp = cp + (item p)
    item p: cp
    i = i + 1
  }
}

def fasta_repeat: n seq: seq {
  _stdout = *stdout* # Speed up dynamic variable lookup.
  i   = 0
  lenOut = 60
  s_length = seq length
  while: { n > 0 } do: {
    if: (n < lenOut) then: { lenOut = n }
    if: ((i + lenOut) < s_length) then: {
      #seq slice(i, lenOut) . println
      _stdout raw_write(seq slice(i, lenOut) << "\n")
      i = i + lenOut
    } else: {
      #seq slice(i, (s_length - i)) . print
      _stdout raw_write(seq slice(i, (s_length - i)))
      i = lenOut - (s_length - i)
      #seq slice(0, i) . println
      _stdout raw_write(seq slice(0, i) << "\n")
    }
    n = n - lenOut
  }
}

def fasta_random: count genelist: list {
  _stdout = *stdout*

  #buff = Array new: WIDTH
  make_cumulative: list

  while: { count > 0 } do: {
    buff = StringIO new
    line = WIDTH min: count
    pos  = 0
    # buff fill("")
    while: { pos < line } do: {
      Last = (Last * A + C) % M
      r = (Last to_f) / M

      i = 0
      # Linear search
      while: { (list[i] p) < r } do: {
        i = i + 1
      }
      # buff at: pos put: (list[i] c)
      buff pos=(pos)
      buff write(list[i] c)
      pos = pos + 1
    }
    # _stdout raw_write(buff join: ""); _stdout raw_write("\n")
    _stdout raw_write(buff string()); _stdout raw_write("\n")
    count = count - line
  }
}

