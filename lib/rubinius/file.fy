def class File {
  @@open_mode_conversions =
    <['read => "r",
      'write => "w",
      'append => "+",
      'at_end => "a",
      'binary => "b",
      'truncate => "w+"]>

  def File open: filename modes: modes_arr with: block {
    # """
    # Opens a File with a given filename, a modes Array and a block.
    # E.g. to open a File with read access and read all lines and print them to STDOUT:
    # File open: \"foo.txt\" modes: [:read] with: |f| {
    #   { f eof? } while_false: {
    #     f readln println
    #   }
    # }
    # """

    modes_str = modes_str: modes_arr
    # TODO: how do we deal with Ruby methods that expect a block?
    # We need a way to let the compiler know if the last argument to
    # a method call should be used as the block (in Ruby: &prob_obj)
    File open: ~[filename, modes_str, block]
  }

  def modes_str: modes_arr {
    str = ""
    modes_arr each: |m| {
      str = str ++ @@open_mode_conversions[m]
    }
    str uniq join
  }
}
