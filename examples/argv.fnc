"This will always get printed, even when required from another file" println; 

ARGV[0] == __FILE__ if_true: {
  "This will get printed, if this file is directly run with fancy" println
}
