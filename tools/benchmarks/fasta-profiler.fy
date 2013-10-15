require: "fasta2"
require: "profiler"

N = 100_000

mute!
start_profile!

fasta_repeat: (2 * N) seq: ALU

fasta_random: (3 * N) genelist: IUB

fasta_random: (5 * N) genelist: HomoSap

stop_profile!
unmute!
Profiler show()
