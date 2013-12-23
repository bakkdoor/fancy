require: "fasta2"

n = ARGV[1]
if: (n nil?) then: {
  "Usage: fancy fasta.fy N" println
  System exit
}
n = n to_i

">ONE Homo sapiens alu" println
fasta_repeat: (2 * n) seq: ALU

">TWO IUB ambiguity codes" println
fasta_random: (3 * n) genelist: IUB

">THREE Homo sapiens frequency" println
fasta_random: (5 * n) genelist: HomoSap
