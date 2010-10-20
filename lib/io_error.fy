class IOError : StdError {
  read_slots: ['filename, 'modes]

  def initialize: message filename: filename {
    super initialize: message
    @filename = filename
  }

  def initialize: message filename: filename modes: modes {
    super initialize: (message ++ "'" ++ filename ++ "'" ++ " with modes: " ++ (modes inspect))
    @filename = filename
    @modes = modes
  }
}
