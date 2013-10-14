
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
#


IUB = <[
  'a => 0.27, 'c => 0.12, 'g => 0.12, 't => 0.27,
  'B => 0.02, 'D => 0.02, 'H => 0.02, 'K => 0.02,
  'M => 0.02, 'N => 0.02, 'R => 0.02, 'S => 0.02,
  'V => 0.02, 'W => 0.02, 'Y => 0.02
]>
HomoSap = <[
  'a => 0.3029549426680,
  'c => 0.1979883004921,
  'g => 0.1975473066391,
  't => 0.3015094502008
]>

def make_cumulative: table {
  prev = false
  table keys each: |c| {
    if: (prev) then: {
      table at: c put: ((table[c]) + (table[prev]))
    }
    prev = c
  }
}

def fasta_repeat: n seq: seq {
  i   = 0
  lenOut = 60
  s_length = seq length
  while: { n > 0 } do: {
    if: (n < lenOut) then: { lenOut = n }
    if: ((i + lenOut) < s_length) then: {
      seq slice(i, lenOut) . println
      i = i + lenOut
    } else: {
      seq slice(i, (s_length - i)) . print
      i = lenOut - (s_length - i)
      seq slice(0, i) . println
    }
    n = n - lenOut
  }
}

def fasta_random: n table: table {
  make_cumulative: table
  buff = Array new: WIDTH
  while: { n > 0 } do: {
    buff fill("")
    line = (WIDTH min: n)
    # for pos := 0; pos < line; pos++
    0 upto: (line - 1) . each: |pos| {
      Last = (Last * A + C) % M
      r = (Last to_f) / M
      table each: |c, p| { # char, probability
        if: (p >= r) then: {
          buff at: pos put: c
          break
        }
      }
    }
    buff join: "" . println
    n = n - line
  }
}

n = ARGV[1]
if: (n nil?) then: {
  "Usage: fancy fasta.fy N" println
  System exit
}
n = n to_i

">ONE Homo sapiens alu" println
fasta_repeat: (2 * n) seq: ALU

">TWO IUB ambiguity codes" println
fasta_random: (3 * n) table: IUB

">THREE Homo sapiens frequency" println
fasta_random: (5 * n) table: HomoSap
