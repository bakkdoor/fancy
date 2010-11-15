ARGV first == "--uselib" . if_do: {
  ARGV shift()
  require: "../lib/compiler"
  require: "../lib/compiler/command"
} else: {
  require: "../.boot/compiler"
  require: "../.boot/compiler/command"
}
Fancy Compiler Command run: ARGV
