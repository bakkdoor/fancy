class Fancy FDoc {
  # A hash to keep all objects to extract documentation from.
  # Having this hash only for FDoc is fine IMHO. As we dont need
  # to use ObjectSpace or anything like that. Just to produce docs.
  @documented_objects = <[]>
  Fancy Documentation on_documentation_set: |object, documentation| {
    @documented_objects store(object, documentation)
  }
}

