# echo.fy
# Outputs contents of files

ARGV[1] if_do: |filename| {
 try {
    File open: filename modes: ['read] with: |f| {
      { f eof? } while_false: {
        f readln println
      }
    }
  } catch IOError => e {
    "[ERROR] " ++ (e message) println
  }
} else: {
  "Usage: fancy echo.fy [filename]" println
}
