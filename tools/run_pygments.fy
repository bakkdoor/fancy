#!/usr/bin/env fancy

STYLE = "emacs"
LINENOS = 1
OUT_DIR = "pygments"
COMMAND = "pygmentize -O full,style=#{STYLE},linenos=#{LINENOS} -o #{OUT_DIR}/%s.html %s"

Directory create!: OUT_DIR

def run_in_dir: dirname {

  "Running in dir: #{dirname}" println

  Dir glob("#{dirname}/**/*.fy") each: |f| {
    "pygmentize #{f}" println
    Directory create!: "#{OUT_DIR}/#{File dirname(f)}"
    System do: $ COMMAND % (f,f)
  }
}

run_in_dir: "lib"
Console newline
run_in_dir: "tests"
