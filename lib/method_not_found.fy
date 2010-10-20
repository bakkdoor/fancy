class MethodNotFoundError : StdError {
  read_slots: ['method_name, 'for_class, 'reason]
  def initialize: method_name for_class: class {
    super initialize: ("Method not found: " ++ method_name ++ " for class: " ++ class)
    @method_name = method_name
    @for_class = class
  }

  def initialize: method_name for_class: class reason: reason {
    super initialize: ("Method not found: " ++ method_name ++ " for class: " ++ class ++ " (" ++ reason ++ ")")
    @method_name = method_name
    @for_class = class
    @reason = reason
  }
}
