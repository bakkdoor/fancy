class Fancy {
  class Message {
    read_write_slots: ('name, 'params)

    def initialize: @name with_params: @params ([]) {
      name: @name
    }

    def name: @name {
      @name_str = @name to_s message_name
    }

    UnaryPattern = /^:([a-z]|[_&\*])+([a-zA-Z0-9_]|([\-\+\?!=\*\/^><%&~]|_))+$/

    def unary_message? {
      UnaryPattern matches?: @name_str
    }

    BinaryPattern = /^:(( / )|( | )|[-+?!=*\/^><%&~]+|(\|\|([-+?!=\*\/^><%&~]|_)))*$/

    def binary_message? {
      BinaryPattern matches?: @name_str
    }

    KeywordPattern = /^[^:]/

    def keyword_message? {
      KeywordPattern matches?: @name_str
    }
  }
}
