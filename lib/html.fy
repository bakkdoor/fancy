class HTML {
  """
  HTML generator class.

  Example:
        require: \"html\"
        html = HTML new: @{
          html: @{
            head: @{ title: \"My Fancy Website\" }
            body: @{
              div: { id: \”main\” } with: \"Hello, Fancy World!\"
            }
          }
        } . to_s

        # html is now:
        \"\"\"
        <html>
          <head>
            <title>
              My Fancy Website
            </title>
          </head>
          <body>
            <div id=\"main\">
              Hello, Fancy World!
            </div>
          </body>
        </html>
        \"\"\"

  """

  def initialize {
    @buf = ""
    @indent = 0
  }

  def initialize: block {
    initialize
    block call: [self]
  }

  def open_tag: name attrs: attrs (<[]>) indent: indent (true) {
    @buf << "\n"
    @buf << (" " * @indent)
    @indent = @indent + 2

    @buf << "<" << name
    unless: (attrs empty?) do: {
      @buf << " "
      attrs each: |k v| {
        @buf << k << "=" << (v to_s inspect)
      } in_between: {
        @buf << " "
      }
    }
    @buf << ">"

    { @indent = @indent - 2 } unless: indent
  }

  def close_tag: name {
    @buf << "\n"
    @indent = @indent - 2
    @buf << (" " * @indent)

    @buf << "</" << name << ">"
  }

  def html_block: tag body: body attrs: attrs (<[]>) {
    tag = tag from: 0 to: -2
    open_tag: tag attrs: attrs
    match body first {
      case Block -> @buf << (body first call: [self])
      case _ -> @buf << "\n" << (" " * @indent) << (body first)
    }
    close_tag: tag
    nil
  }

  def unknown_message: m with_params: p {
    match m to_s {
      case /with:$/ ->
        tag = m to_s substitute: /with:$/ with: ""
        html_block: tag body: (p rest) attrs: (p first to_hash)
      case _ ->
        html_block: (m to_s) body: p
    }
    nil
  }

  def br {
    @buf << "\n" << (" " * @indent)
    @buf << "<br/>"
    nil
  }

  def input: attrs {
    open_tag: "input" attrs: (attrs to_hash) indent: false
    nil
  }

  def to_s {
    @buf from: 1 to: -1 . to_s
  }
}