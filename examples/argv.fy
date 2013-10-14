# argv.fy
# Example of fancy's interface for command line arguments

"This will always get printed, even when required from another file" println

__FILE__ if_main: {
  "This will get printed, if this file is directly run with fancy" println
}
