class Rubinius CompiledMethod {
  forwards_unary_ruby_methods

  def selectors_with_args {
    local_names = local_names to_a
    if: (required_args > 0) then: {
      name to_s split: ":" . map_with_index: |sel i| {
        "#{sel}: #{local_names[i]}"
      } . join: " "
    } else: {
      name to_s rest
    }
  }

  def definition_line {
    # don't use documentation#to_s since we need original docstring as written in source file to calculate the correct lines#
    docstring = ""
    if: documentation then: {
      docstring = documentation docs join: "\n"
    }
    if: (lines size > 3) then: {
      lines[3] - (docstring lines size)
    } else: {
      0 # UNKNOWN?
    }
  }

  def last_line {
    defined_line
  }
}
