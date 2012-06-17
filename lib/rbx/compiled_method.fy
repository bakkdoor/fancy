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
    lines[3] - (documentation to_s lines size) - 2
  }

  def last_line {
    defined_line
  }
}
