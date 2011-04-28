# echo.fy
# Outputs contents of files

ARGV[1] if_true: |filename| {
 try {
    File open: filename modes: ['read] with: |f| {
      until: { f eof? } do: {
        f readln println
      }
    }
  } catch IOError => e {
    "[ERROR] " ++ (e message) println
  }
} else: {
  "Usage: fancy echo.fy [filename]" println
}
