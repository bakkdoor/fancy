# html_generator.fy
# Simple HTML generator written in fancy

class String {
  def but_last {
    # same as:  self from: 0 to: -2
    # and:      self from: 0 to: (self size - 2)
    self[[0,-2]]
  }
}

class HTML {
  def initialize {
    @buf = ""
  }

  def initialize: block {
    initialize
    block call_with_receiver: self
    self
  }

  def open_tag: name attrs: attrs (<[]>) {
    @buf << "<" << (name but_last)
    unless: (attrs empty?) do: {
      @buf << " "
      attrs each: |k v| {
        @buf << k << "=" << (v inspect)
      } in_between: {
        @buf << " "
      }
    }
    @buf << ">"
  }

  def close_tag: name {
    @buf << "</" << (name but_last) << ">"
  }

  def html_block: tag body: body attrs: attrs (<[]>) {
    open_tag: tag attrs: attrs
    match body first {
      case Block -> @buf << (body first call)
      case _ -> @buf << (body first)
    }
    close_tag: tag
  }

  def unknown_message: m with_params: p {
    match m to_s {
      case /with:$/ ->
        tag = m to_s substitute: /with:$/ with: ""
        html_block: tag body: (p rest) attrs: (p first)
      case _ ->
        html_block: (m to_s) body: p
    }
    nil
  }

  def to_s {
    @buf
  }
}

# lets generate some simple HTML output :)
HTML new: |h| {
  html: {
    body: <['id => "body id" ]> with: {
      div: {
        "hello, world!"
      }
      div: {
        p: {
          "OKIDOKI"
        }
      }
      div: {
        h3: {
          "oh no!"
        }
      }
    }
  }
} . println
