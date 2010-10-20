# simple html generator example
# this isn't to be taken very seriously but it shows some syntax &
# features of Fancy :)

class String {
  def but_last {
    # same as:  self from: 0 to: -2
    # and:      self from: 0 to: (self size - 2)
    self[[0,-2]]
  }
}

class HTML {
  def open_tag: name {
    "<" ++ (name but_last) ++ ">"
  }

  def close_tag: name {
    "</" ++ (name but_last) ++ ">"
  }

  def unknown_message: name with_params: params {
    str = open_tag: name

    body = params first call
    body is_a?: Array . if_true: {
      body = body join
    }

    str ++ body ++ (close_tag: name)
  }
}

# lets generate some simple HTML output )
h = HTML new
h html: {
  h body: {
    [
     h div: {
       "hello, world!"
     },
     h div: {
       h p: {
         "OKIDOKI"
       }
     },
     h div: {
       h h3: {
         "oh no!"
       }
     }
    ]
  }
} . println
