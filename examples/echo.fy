# echo.fy
# Outputs contents of files

if: (ARGV[1]) then: |filename| {
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
