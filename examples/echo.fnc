# echo.fnc - outputs contents of files.

ARGV[1] if_do: |filename| {
 try {
    File open: filename modes: [:read] with: |f| {
      { f eof? } while_false: {
        f readln println
      }
    }
  } rescue IOError => e {
    "[ERROR] " ++ (e message) println
  }
} else: {
  "Usage: fancy echo.fnc [filename]" println
}
