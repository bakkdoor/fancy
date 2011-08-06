class Fancy::KPegParser
# STANDALONE START
    def setup_parser(str, debug=false)
      @string = str
      @pos = 0
      @memoizations = Hash.new { |h,k| h[k] = {} }
      @refargs = Array.new
      @result = nil
      @failed_rule = nil
      @failing_rule_offset = -1

      setup_foreign_grammar
    end

    # This is distinct from setup_parser so that a standalone parser
    # can redefine #initialize and still have access to the proper
    # parser setup code.
    #
    def initialize(str, debug=false)
      setup_parser(str, debug)
    end

    attr_reader :string
    attr_reader :failing_rule_offset
    attr_accessor :result, :pos

    # STANDALONE START
    def current_column(target=pos)
      if target > 0 && c = string.rindex("\n", target-1)
        return [1, target - 1 - c].max
      end
      
      target + 1
    end

    def current_line(target=pos)
      cur_offset = 0
      cur_line = 0

      string.each_line do |line|
        cur_line += 1
        cur_offset += line.size
        return cur_line if cur_offset > target
      end

      cur_line + 1
    end

    def lines
      lines = []
      string.each_line { |l| lines << l }
      lines
    end

    #

    def get_text(start)
      @string[start..@pos-1]
    end

    def show_pos
      width = 10
      if @pos < width
        "#{@pos} (\"#{@string[0,@pos]}\" @ \"#{@string[@pos,width]}\")"
      else
        "#{@pos} (\"... #{@string[@pos - width, width]}\" @ \"#{@string[@pos,width]}\")"
      end
    end

    def failure_info
      l = current_line @failing_rule_offset
      c = current_column @failing_rule_offset

      if @failed_rule.kind_of? Symbol
        info = self.class::Rules[@failed_rule]
        "line #{l}, column #{c}: failed rule '#{info.name}' = '#{info.rendered}'"
      else
        "line #{l}, column #{c}: failed rule '#{@failed_rule}'"
      end
    end

    def failure_caret
      l = current_line @failing_rule_offset
      c = current_column @failing_rule_offset

      line = lines[l-1]
      "#{line}\n#{' ' * (c - 1)}^"
    end

    def failure_character
      l = current_line @failing_rule_offset
      c = current_column @failing_rule_offset
      lines[l-1][c-1, 1]
    end

    def failure_oneline
      l = current_line @failing_rule_offset
      c = current_column @failing_rule_offset

      char = lines[l-1][c-1, 1]

      if @failed_rule.kind_of? Symbol
        info = self.class::Rules[@failed_rule]
        "@#{l}:#{c} failed rule '#{info.name}', got '#{char}'"
      else
        "@#{l}:#{c} failed rule '#{@failed_rule}', got '#{char}'"
      end
    end

    class ParseError < RuntimeError
    end

    def raise_error
      raise ParseError, failure_oneline
    end

    def show_error(io=STDOUT)
      error_pos = @failing_rule_offset
      line_no = current_line(error_pos)
      col_no = current_column(error_pos)

      io.puts "On line #{line_no}, column #{col_no}:"

      if @failed_rule.kind_of? Symbol
        info = self.class::Rules[@failed_rule]
        io.puts "Failed to match '#{info.rendered}' (rule '#{info.name}')"
      else
        io.puts "Failed to match rule '#{@failed_rule}'"
      end

      io.puts "Got: #{string[error_pos,1].inspect}"
      line = lines[line_no-1]
      io.puts "=> #{line}"
      io.print(" " * (col_no + 3))
      io.puts "^"
    end

    def set_failed_rule(name)
      if @pos > @failing_rule_offset
        @failed_rule = name
        @failing_rule_offset = @pos
      end
    end

    attr_reader :failed_rule

    def match_string(str)
      len = str.size
      if @string[pos,len] == str
        @pos += len
        return str
      end

      return nil
    end

    def scan(reg)
      if m = reg.match(@string[@pos..-1])
        width = m.end(0)
        @pos += width
        return true
      end

      return nil
    end

    if "".respond_to? :getbyte
      def get_byte
        if @pos >= @string.size
          return nil
        end

        s = @string.getbyte @pos
        @pos += 1
        s
      end
    else
      def get_byte
        if @pos >= @string.size
          return nil
        end

        s = @string[@pos]
        @pos += 1
        s
      end
    end

    def parse(rule=nil)
      if !rule
        _root ? true : false
      else
        # This is not shared with code_generator.rb so this can be standalone
        method = rule.gsub("-","_hyphen_")
        __send__("_#{method}") ? true : false
      end
    end

    class LeftRecursive
      def initialize(detected=false)
        @detected = detected
      end

      attr_accessor :detected
    end

    class MemoEntry
      def initialize(ans, pos)
        @ans = ans
        @pos = pos
        @uses = 1
        @result = nil
      end

      attr_reader :ans, :pos, :uses, :result

      def inc!
        @uses += 1
      end

      def move!(ans, pos, result)
        @ans = ans
        @pos = pos
        @result = result
      end
    end

    def external_invoke(other, rule, *args)
      old_pos = @pos
      old_string = @string

      @pos = other.pos
      @string = other.string

      begin
        if val = __send__(rule, *args)
          other.pos = @pos
          other.result = @result
        else
          other.set_failed_rule "#{self.class}##{rule}"
        end
        val
      ensure
        @pos = old_pos
        @string = old_string
      end
    end

    def apply_with_args(rule, *args)
      memo_key = [rule, args]
      if m = @memoizations[memo_key][@pos]
        m.inc!

        prev = @pos
        @pos = m.pos
        if m.ans.kind_of? LeftRecursive
          m.ans.detected = true
          return nil
        end

        @result = m.result

        return m.ans
      else
        lr = LeftRecursive.new(false)
        m = MemoEntry.new(lr, @pos)
        @memoizations[memo_key][@pos] = m
        start_pos = @pos

        ans = __send__ rule, *args

        m.move! ans, @pos, @result

        # Don't bother trying to grow the left recursion
        # if it's failing straight away (thus there is no seed)
        if ans and lr.detected
          return grow_lr(rule, args, start_pos, m)
        else
          return ans
        end

        return ans
      end
    end

    def apply(rule)
      if m = @memoizations[rule][@pos]
        m.inc!

        prev = @pos
        @pos = m.pos
        if m.ans.kind_of? LeftRecursive
          m.ans.detected = true
          return nil
        end

        @result = m.result

        return m.ans
      else
        lr = LeftRecursive.new(false)
        m = MemoEntry.new(lr, @pos)
        @memoizations[rule][@pos] = m
        start_pos = @pos

        ans = __send__ rule

        m.move! ans, @pos, @result

        # Don't bother trying to grow the left recursion
        # if it's failing straight away (thus there is no seed)
        if ans and lr.detected
          return grow_lr(rule, nil, start_pos, m)
        else
          return ans
        end

        return ans
      end
    end

    def grow_lr(rule, args, start_pos, m)
      while true
        @pos = start_pos
        @result = m.result

        if args
          ans = __send__ rule, *args
        else
          ans = __send__ rule
        end
        return nil unless ans

        break if @pos <= m.pos

        m.move! ans, @pos, @result
      end

      @result = m.result
      @pos = m.pos
      return m.ans
    end

    class RuleInfo
      def initialize(name, rendered)
        @name = name
        @rendered = rendered
      end

      attr_reader :name, :rendered
    end

    def self.rule_info(name, rendered)
      RuleInfo.new(name, rendered)
    end

    #


    class Position
      attr_reader :line, :column
      def initialize(line, column)
        @line, @column = line, column
      end
    end

    class Node
      attr_reader :pos, :name, :args
      def initialize(pos, name, *args)
        @pos, @name, @args = pos, name, args
      end
    end

    def node(pos, name, *args)
      Node.new(pos, name, *args)
    end

    def position(line = current_line, column = current_column)
      Position.new(line, column)
    end

    def ident?(text)
      !%w[ case ].include?(text)
    end

    def oper?(text)
      !%w[ =  => ].include?(text)
    end

    def body_nil(p = position)
      node(p, :body, node(p, :chain, node(p, :nil)))
    end

    def text_node(p, parts)
      parts = parts.compact
      return node(p, :text, "") if parts.empty?
      ary = parts.dup
      m = ary.shift
      if ary.empty?
        unless m.name == :text
          m = node(p, :chain, m, node(p, :message, "to_s"))
        end
        return m
      end
      node(p, :chain, m, *ary.map { |a| node(p, :message, "++", a) })
    end



  def setup_foreign_grammar; end

  # root = - body:b - !. {b}
  def _root

    _save = self.pos
    while true # sequence
      _tmp = apply(:__hyphen_)
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = apply(:_body)
      b = @result
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = apply(:__hyphen_)
      unless _tmp
        self.pos = _save
        break
      end
      _save1 = self.pos
      _tmp = get_byte
      _tmp = _tmp ? nil : true
      self.pos = _save1
      unless _tmp
        self.pos = _save
        break
      end
      @result = begin; b; end
      _tmp = true
      unless _tmp
        self.pos = _save
      end
      break
    end # end sequence

    set_failed_rule :_root unless _tmp
    return _tmp
  end

  # space = (" " | "\t" | "\\" nl)
  def _space

    _save = self.pos
    while true # choice
      _tmp = match_string(" ")
      break if _tmp
      self.pos = _save
      _tmp = match_string("\t")
      break if _tmp
      self.pos = _save

      _save1 = self.pos
      while true # sequence
        _tmp = match_string("\\")
        unless _tmp
          self.pos = _save1
          break
        end
        _tmp = apply(:_nl)
        unless _tmp
          self.pos = _save1
        end
        break
      end # end sequence

      break if _tmp
      self.pos = _save
      break
    end # end choice

    set_failed_rule :_space unless _tmp
    return _tmp
  end

  # nl = ("\n" | "\n" | ";")
  def _nl

    _save = self.pos
    while true # choice
      _tmp = match_string("\n")
      break if _tmp
      self.pos = _save
      _tmp = match_string("\r\n")
      break if _tmp
      self.pos = _save
      _tmp = match_string(";")
      break if _tmp
      self.pos = _save
      break
    end # end choice

    set_failed_rule :_nl unless _tmp
    return _tmp
  end

  # comment = "#" /.*?$/
  def _comment

    _save = self.pos
    while true # sequence
      _tmp = match_string("#")
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = scan(/\A(?-mix:.*?$)/)
      unless _tmp
        self.pos = _save
      end
      break
    end # end sequence

    set_failed_rule :_comment unless _tmp
    return _tmp
  end

  # - = (comment | space | nl)*
  def __hyphen_
    while true

      _save1 = self.pos
      while true # choice
        _tmp = apply(:_comment)
        break if _tmp
        self.pos = _save1
        _tmp = apply(:_space)
        break if _tmp
        self.pos = _save1
        _tmp = apply(:_nl)
        break if _tmp
        self.pos = _save1
        break
      end # end choice

      break unless _tmp
    end
    _tmp = true
    set_failed_rule :__hyphen_ unless _tmp
    return _tmp
  end

  # p = &. {position}
  def _p

    _save = self.pos
    while true # sequence
      _save1 = self.pos
      _tmp = get_byte
      self.pos = _save1
      unless _tmp
        self.pos = _save
        break
      end
      @result = begin; position; end
      _tmp = true
      unless _tmp
        self.pos = _save
      end
      break
    end # end sequence

    set_failed_rule :_p unless _tmp
    return _tmp
  end

  # body = (body:b - chain:c { b.args.push c; b } | chain:c {node(c.pos, :body, c)})
  def _body

    _save = self.pos
    while true # choice

      _save1 = self.pos
      while true # sequence
        _tmp = apply(:_body)
        b = @result
        unless _tmp
          self.pos = _save1
          break
        end
        _tmp = apply(:__hyphen_)
        unless _tmp
          self.pos = _save1
          break
        end
        _tmp = apply(:_chain)
        c = @result
        unless _tmp
          self.pos = _save1
          break
        end
        @result = begin;  b.args.push c; b ; end
        _tmp = true
        unless _tmp
          self.pos = _save1
        end
        break
      end # end sequence

      break if _tmp
      self.pos = _save

      _save2 = self.pos
      while true # sequence
        _tmp = apply(:_chain)
        c = @result
        unless _tmp
          self.pos = _save2
          break
        end
        @result = begin; node(c.pos, :body, c); end
        _tmp = true
        unless _tmp
          self.pos = _save2
        end
        break
      end # end sequence

      break if _tmp
      self.pos = _save
      break
    end # end choice

    set_failed_rule :_body unless _tmp
    return _tmp
  end

  # chain = (chain:c space* "." !(&".") - (ruby | message):m { c.args.push m; c } | chain:c space* "." !(&".") {node(c.pos, :chain, c)} | chain:c space* access:m { c.args.push m; c } | chain:c space+ (ruby | message):m { c.args.push m; c } | range:r {node(r.pos, :chain, r)} | p:p value:v {node(p, :chain, v)})
  def _chain

    _save = self.pos
    while true # choice

      _save1 = self.pos
      while true # sequence
        _tmp = apply(:_chain)
        c = @result
        unless _tmp
          self.pos = _save1
          break
        end
        while true
          _tmp = apply(:_space)
          break unless _tmp
        end
        _tmp = true
        unless _tmp
          self.pos = _save1
          break
        end
        _tmp = match_string(".")
        unless _tmp
          self.pos = _save1
          break
        end
        _save3 = self.pos
        _save4 = self.pos
        _tmp = match_string(".")
        self.pos = _save4
        _tmp = _tmp ? nil : true
        self.pos = _save3
        unless _tmp
          self.pos = _save1
          break
        end
        _tmp = apply(:__hyphen_)
        unless _tmp
          self.pos = _save1
          break
        end

        _save5 = self.pos
        while true # choice
          _tmp = apply(:_ruby)
          break if _tmp
          self.pos = _save5
          _tmp = apply(:_message)
          break if _tmp
          self.pos = _save5
          break
        end # end choice

        m = @result
        unless _tmp
          self.pos = _save1
          break
        end
        @result = begin;  c.args.push m; c ; end
        _tmp = true
        unless _tmp
          self.pos = _save1
        end
        break
      end # end sequence

      break if _tmp
      self.pos = _save

      _save6 = self.pos
      while true # sequence
        _tmp = apply(:_chain)
        c = @result
        unless _tmp
          self.pos = _save6
          break
        end
        while true
          _tmp = apply(:_space)
          break unless _tmp
        end
        _tmp = true
        unless _tmp
          self.pos = _save6
          break
        end
        _tmp = match_string(".")
        unless _tmp
          self.pos = _save6
          break
        end
        _save8 = self.pos
        _save9 = self.pos
        _tmp = match_string(".")
        self.pos = _save9
        _tmp = _tmp ? nil : true
        self.pos = _save8
        unless _tmp
          self.pos = _save6
          break
        end
        @result = begin; node(c.pos, :chain, c); end
        _tmp = true
        unless _tmp
          self.pos = _save6
        end
        break
      end # end sequence

      break if _tmp
      self.pos = _save

      _save10 = self.pos
      while true # sequence
        _tmp = apply(:_chain)
        c = @result
        unless _tmp
          self.pos = _save10
          break
        end
        while true
          _tmp = apply(:_space)
          break unless _tmp
        end
        _tmp = true
        unless _tmp
          self.pos = _save10
          break
        end
        _tmp = apply(:_access)
        m = @result
        unless _tmp
          self.pos = _save10
          break
        end
        @result = begin;  c.args.push m; c ; end
        _tmp = true
        unless _tmp
          self.pos = _save10
        end
        break
      end # end sequence

      break if _tmp
      self.pos = _save

      _save12 = self.pos
      while true # sequence
        _tmp = apply(:_chain)
        c = @result
        unless _tmp
          self.pos = _save12
          break
        end
        _save13 = self.pos
        _tmp = apply(:_space)
        if _tmp
          while true
            _tmp = apply(:_space)
            break unless _tmp
          end
          _tmp = true
        else
          self.pos = _save13
        end
        unless _tmp
          self.pos = _save12
          break
        end

        _save14 = self.pos
        while true # choice
          _tmp = apply(:_ruby)
          break if _tmp
          self.pos = _save14
          _tmp = apply(:_message)
          break if _tmp
          self.pos = _save14
          break
        end # end choice

        m = @result
        unless _tmp
          self.pos = _save12
          break
        end
        @result = begin;  c.args.push m; c ; end
        _tmp = true
        unless _tmp
          self.pos = _save12
        end
        break
      end # end sequence

      break if _tmp
      self.pos = _save

      _save15 = self.pos
      while true # sequence
        _tmp = apply(:_range)
        r = @result
        unless _tmp
          self.pos = _save15
          break
        end
        @result = begin; node(r.pos, :chain, r); end
        _tmp = true
        unless _tmp
          self.pos = _save15
        end
        break
      end # end sequence

      break if _tmp
      self.pos = _save

      _save16 = self.pos
      while true # sequence
        _tmp = apply(:_p)
        p = @result
        unless _tmp
          self.pos = _save16
          break
        end
        _tmp = apply(:_value)
        v = @result
        unless _tmp
          self.pos = _save16
          break
        end
        @result = begin; node(p, :chain, v); end
        _tmp = true
        unless _tmp
          self.pos = _save16
        end
        break
      end # end sequence

      break if _tmp
      self.pos = _save
      break
    end # end choice

    set_failed_rule :_chain unless _tmp
    return _tmp
  end

  # args = (args:a space* "," - body:c { a + [c] } | body:c {[c]})
  def _args

    _save = self.pos
    while true # choice

      _save1 = self.pos
      while true # sequence
        _tmp = apply(:_args)
        a = @result
        unless _tmp
          self.pos = _save1
          break
        end
        while true
          _tmp = apply(:_space)
          break unless _tmp
        end
        _tmp = true
        unless _tmp
          self.pos = _save1
          break
        end
        _tmp = match_string(",")
        unless _tmp
          self.pos = _save1
          break
        end
        _tmp = apply(:__hyphen_)
        unless _tmp
          self.pos = _save1
          break
        end
        _tmp = apply(:_body)
        c = @result
        unless _tmp
          self.pos = _save1
          break
        end
        @result = begin;  a + [c] ; end
        _tmp = true
        unless _tmp
          self.pos = _save1
        end
        break
      end # end sequence

      break if _tmp
      self.pos = _save

      _save3 = self.pos
      while true # sequence
        _tmp = apply(:_body)
        c = @result
        unless _tmp
          self.pos = _save3
          break
        end
        @result = begin; [c]; end
        _tmp = true
        unless _tmp
          self.pos = _save3
        end
        break
      end # end sequence

      break if _tmp
      self.pos = _save
      break
    end # end choice

    set_failed_rule :_args unless _tmp
    return _tmp
  end

  # ruby_name = < (ident | const | oper | "=")+ > {text}
  def _ruby_name

    _save = self.pos
    while true # sequence
      _text_start = self.pos
      _save1 = self.pos

      _save2 = self.pos
      while true # choice
        _tmp = apply(:_ident)
        break if _tmp
        self.pos = _save2
        _tmp = apply(:_const)
        break if _tmp
        self.pos = _save2
        _tmp = apply(:_oper)
        break if _tmp
        self.pos = _save2
        _tmp = match_string("=")
        break if _tmp
        self.pos = _save2
        break
      end # end choice

      if _tmp
        while true

          _save3 = self.pos
          while true # choice
            _tmp = apply(:_ident)
            break if _tmp
            self.pos = _save3
            _tmp = apply(:_const)
            break if _tmp
            self.pos = _save3
            _tmp = apply(:_oper)
            break if _tmp
            self.pos = _save3
            _tmp = match_string("=")
            break if _tmp
            self.pos = _save3
            break
          end # end choice

          break unless _tmp
        end
        _tmp = true
      else
        self.pos = _save1
      end
      if _tmp
        text = get_text(_text_start)
      end
      unless _tmp
        self.pos = _save
        break
      end
      @result = begin; text; end
      _tmp = true
      unless _tmp
        self.pos = _save
      end
      break
    end # end sequence

    set_failed_rule :_ruby_name unless _tmp
    return _tmp
  end

  # ruby = (p:p ruby_name:n "(" - args?:a - ")" space+ block:b {node(p, :ruby, n, b, *Array(a))} | p:p ruby_name:n "(" - args?:a - ")" {node(p, :ruby, n, nil, *Array(a))})
  def _ruby

    _save = self.pos
    while true # choice

      _save1 = self.pos
      while true # sequence
        _tmp = apply(:_p)
        p = @result
        unless _tmp
          self.pos = _save1
          break
        end
        _tmp = apply(:_ruby_name)
        n = @result
        unless _tmp
          self.pos = _save1
          break
        end
        _tmp = match_string("(")
        unless _tmp
          self.pos = _save1
          break
        end
        _tmp = apply(:__hyphen_)
        unless _tmp
          self.pos = _save1
          break
        end
        _save2 = self.pos
        _tmp = apply(:_args)
        @result = nil unless _tmp
        unless _tmp
          _tmp = true
          self.pos = _save2
        end
        a = @result
        unless _tmp
          self.pos = _save1
          break
        end
        _tmp = apply(:__hyphen_)
        unless _tmp
          self.pos = _save1
          break
        end
        _tmp = match_string(")")
        unless _tmp
          self.pos = _save1
          break
        end
        _save3 = self.pos
        _tmp = apply(:_space)
        if _tmp
          while true
            _tmp = apply(:_space)
            break unless _tmp
          end
          _tmp = true
        else
          self.pos = _save3
        end
        unless _tmp
          self.pos = _save1
          break
        end
        _tmp = apply(:_block)
        b = @result
        unless _tmp
          self.pos = _save1
          break
        end
        @result = begin; node(p, :ruby, n, b, *Array(a)); end
        _tmp = true
        unless _tmp
          self.pos = _save1
        end
        break
      end # end sequence

      break if _tmp
      self.pos = _save

      _save4 = self.pos
      while true # sequence
        _tmp = apply(:_p)
        p = @result
        unless _tmp
          self.pos = _save4
          break
        end
        _tmp = apply(:_ruby_name)
        n = @result
        unless _tmp
          self.pos = _save4
          break
        end
        _tmp = match_string("(")
        unless _tmp
          self.pos = _save4
          break
        end
        _tmp = apply(:__hyphen_)
        unless _tmp
          self.pos = _save4
          break
        end
        _save5 = self.pos
        _tmp = apply(:_args)
        @result = nil unless _tmp
        unless _tmp
          _tmp = true
          self.pos = _save5
        end
        a = @result
        unless _tmp
          self.pos = _save4
          break
        end
        _tmp = apply(:__hyphen_)
        unless _tmp
          self.pos = _save4
          break
        end
        _tmp = match_string(")")
        unless _tmp
          self.pos = _save4
          break
        end
        @result = begin; node(p, :ruby, n, nil, *Array(a)); end
        _tmp = true
        unless _tmp
          self.pos = _save4
        end
        break
      end # end sequence

      break if _tmp
      self.pos = _save
      break
    end # end choice

    set_failed_rule :_ruby unless _tmp
    return _tmp
  end

  # access = (p:p "[" - chain:a - "]:" space+ - value:b {node(p, :opmsg, "[]",a,b)} | p:p "[" - chain:a - "]" {node(p, :opmsg, "[]", a)})
  def _access

    _save = self.pos
    while true # choice

      _save1 = self.pos
      while true # sequence
        _tmp = apply(:_p)
        p = @result
        unless _tmp
          self.pos = _save1
          break
        end
        _tmp = match_string("[")
        unless _tmp
          self.pos = _save1
          break
        end
        _tmp = apply(:__hyphen_)
        unless _tmp
          self.pos = _save1
          break
        end
        _tmp = apply(:_chain)
        a = @result
        unless _tmp
          self.pos = _save1
          break
        end
        _tmp = apply(:__hyphen_)
        unless _tmp
          self.pos = _save1
          break
        end
        _tmp = match_string("]:")
        unless _tmp
          self.pos = _save1
          break
        end
        _save2 = self.pos
        _tmp = apply(:_space)
        if _tmp
          while true
            _tmp = apply(:_space)
            break unless _tmp
          end
          _tmp = true
        else
          self.pos = _save2
        end
        unless _tmp
          self.pos = _save1
          break
        end
        _tmp = apply(:__hyphen_)
        unless _tmp
          self.pos = _save1
          break
        end
        _tmp = apply(:_value)
        b = @result
        unless _tmp
          self.pos = _save1
          break
        end
        @result = begin; node(p, :opmsg, "[]",a,b); end
        _tmp = true
        unless _tmp
          self.pos = _save1
        end
        break
      end # end sequence

      break if _tmp
      self.pos = _save

      _save3 = self.pos
      while true # sequence
        _tmp = apply(:_p)
        p = @result
        unless _tmp
          self.pos = _save3
          break
        end
        _tmp = match_string("[")
        unless _tmp
          self.pos = _save3
          break
        end
        _tmp = apply(:__hyphen_)
        unless _tmp
          self.pos = _save3
          break
        end
        _tmp = apply(:_chain)
        a = @result
        unless _tmp
          self.pos = _save3
          break
        end
        _tmp = apply(:__hyphen_)
        unless _tmp
          self.pos = _save3
          break
        end
        _tmp = match_string("]")
        unless _tmp
          self.pos = _save3
          break
        end
        @result = begin; node(p, :opmsg, "[]", a); end
        _tmp = true
        unless _tmp
          self.pos = _save3
        end
        break
      end # end sequence

      break if _tmp
      self.pos = _save
      break
    end # end choice

    set_failed_rule :_access unless _tmp
    return _tmp
  end

  # message = (p:p oper:o (space* "." !(&"."))? - value:v {node(p, :opmsg, o, v)} | collon:c {c} | p:p ident:i {node(p, :message, i)})
  def _message

    _save = self.pos
    while true # choice

      _save1 = self.pos
      while true # sequence
        _tmp = apply(:_p)
        p = @result
        unless _tmp
          self.pos = _save1
          break
        end
        _tmp = apply(:_oper)
        o = @result
        unless _tmp
          self.pos = _save1
          break
        end
        _save2 = self.pos

        _save3 = self.pos
        while true # sequence
          while true
            _tmp = apply(:_space)
            break unless _tmp
          end
          _tmp = true
          unless _tmp
            self.pos = _save3
            break
          end
          _tmp = match_string(".")
          unless _tmp
            self.pos = _save3
            break
          end
          _save5 = self.pos
          _save6 = self.pos
          _tmp = match_string(".")
          self.pos = _save6
          _tmp = _tmp ? nil : true
          self.pos = _save5
          unless _tmp
            self.pos = _save3
          end
          break
        end # end sequence

        unless _tmp
          _tmp = true
          self.pos = _save2
        end
        unless _tmp
          self.pos = _save1
          break
        end
        _tmp = apply(:__hyphen_)
        unless _tmp
          self.pos = _save1
          break
        end
        _tmp = apply(:_value)
        v = @result
        unless _tmp
          self.pos = _save1
          break
        end
        @result = begin; node(p, :opmsg, o, v); end
        _tmp = true
        unless _tmp
          self.pos = _save1
        end
        break
      end # end sequence

      break if _tmp
      self.pos = _save

      _save7 = self.pos
      while true # sequence
        _tmp = apply(:_collon)
        c = @result
        unless _tmp
          self.pos = _save7
          break
        end
        @result = begin; c; end
        _tmp = true
        unless _tmp
          self.pos = _save7
        end
        break
      end # end sequence

      break if _tmp
      self.pos = _save

      _save8 = self.pos
      while true # sequence
        _tmp = apply(:_p)
        p = @result
        unless _tmp
          self.pos = _save8
          break
        end
        _tmp = apply(:_ident)
        i = @result
        unless _tmp
          self.pos = _save8
          break
        end
        @result = begin; node(p, :message, i); end
        _tmp = true
        unless _tmp
          self.pos = _save8
        end
        break
      end # end sequence

      break if _tmp
      self.pos = _save
      break
    end # end choice

    set_failed_rule :_message unless _tmp
    return _tmp
  end

  # collon = (collon:c space+ ident:i ":" space+ - value:v {c.args.push i, v; c} | p:p ident:i ":" space+ - value:v {node(p, :message, i, v)})
  def _collon

    _save = self.pos
    while true # choice

      _save1 = self.pos
      while true # sequence
        _tmp = apply(:_collon)
        c = @result
        unless _tmp
          self.pos = _save1
          break
        end
        _save2 = self.pos
        _tmp = apply(:_space)
        if _tmp
          while true
            _tmp = apply(:_space)
            break unless _tmp
          end
          _tmp = true
        else
          self.pos = _save2
        end
        unless _tmp
          self.pos = _save1
          break
        end
        _tmp = apply(:_ident)
        i = @result
        unless _tmp
          self.pos = _save1
          break
        end
        _tmp = match_string(":")
        unless _tmp
          self.pos = _save1
          break
        end
        _save3 = self.pos
        _tmp = apply(:_space)
        if _tmp
          while true
            _tmp = apply(:_space)
            break unless _tmp
          end
          _tmp = true
        else
          self.pos = _save3
        end
        unless _tmp
          self.pos = _save1
          break
        end
        _tmp = apply(:__hyphen_)
        unless _tmp
          self.pos = _save1
          break
        end
        _tmp = apply(:_value)
        v = @result
        unless _tmp
          self.pos = _save1
          break
        end
        @result = begin; c.args.push i, v; c; end
        _tmp = true
        unless _tmp
          self.pos = _save1
        end
        break
      end # end sequence

      break if _tmp
      self.pos = _save

      _save4 = self.pos
      while true # sequence
        _tmp = apply(:_p)
        p = @result
        unless _tmp
          self.pos = _save4
          break
        end
        _tmp = apply(:_ident)
        i = @result
        unless _tmp
          self.pos = _save4
          break
        end
        _tmp = match_string(":")
        unless _tmp
          self.pos = _save4
          break
        end
        _save5 = self.pos
        _tmp = apply(:_space)
        if _tmp
          while true
            _tmp = apply(:_space)
            break unless _tmp
          end
          _tmp = true
        else
          self.pos = _save5
        end
        unless _tmp
          self.pos = _save4
          break
        end
        _tmp = apply(:__hyphen_)
        unless _tmp
          self.pos = _save4
          break
        end
        _tmp = apply(:_value)
        v = @result
        unless _tmp
          self.pos = _save4
          break
        end
        @result = begin; node(p, :message, i, v); end
        _tmp = true
        unless _tmp
          self.pos = _save4
        end
        break
      end # end sequence

      break if _tmp
      self.pos = _save
      break
    end # end choice

    set_failed_rule :_collon unless _tmp
    return _tmp
  end

  # block = (p:p block_args:a - curly:b {node(p, :block, a, b)} | curly:b {node(p, :block, [], b)})
  def _block

    _save = self.pos
    while true # choice

      _save1 = self.pos
      while true # sequence
        _tmp = apply(:_p)
        p = @result
        unless _tmp
          self.pos = _save1
          break
        end
        _tmp = apply(:_block_args)
        a = @result
        unless _tmp
          self.pos = _save1
          break
        end
        _tmp = apply(:__hyphen_)
        unless _tmp
          self.pos = _save1
          break
        end
        _tmp = apply(:_curly)
        b = @result
        unless _tmp
          self.pos = _save1
          break
        end
        @result = begin; node(p, :block, a, b); end
        _tmp = true
        unless _tmp
          self.pos = _save1
        end
        break
      end # end sequence

      break if _tmp
      self.pos = _save

      _save2 = self.pos
      while true # sequence
        _tmp = apply(:_curly)
        b = @result
        unless _tmp
          self.pos = _save2
          break
        end
        @result = begin; node(p, :block, [], b); end
        _tmp = true
        unless _tmp
          self.pos = _save2
        end
        break
      end # end sequence

      break if _tmp
      self.pos = _save
      break
    end # end choice

    set_failed_rule :_block unless _tmp
    return _tmp
  end

  # block_args = "|" space* (tuple_items(&identifier) | block_params):a space* "|" {a}
  def _block_args

    _save = self.pos
    while true # sequence
      _tmp = match_string("|")
      unless _tmp
        self.pos = _save
        break
      end
      while true
        _tmp = apply(:_space)
        break unless _tmp
      end
      _tmp = true
      unless _tmp
        self.pos = _save
        break
      end

      _save2 = self.pos
      while true # choice
        _tmp = apply_with_args(:_tuple_items, (@refargs[0] ||= Proc.new {
          _tmp = apply(:_identifier)
          _tmp
        }))
        break if _tmp
        self.pos = _save2
        _tmp = apply(:_block_params)
        break if _tmp
        self.pos = _save2
        break
      end # end choice

      a = @result
      unless _tmp
        self.pos = _save
        break
      end
      while true
        _tmp = apply(:_space)
        break unless _tmp
      end
      _tmp = true
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = match_string("|")
      unless _tmp
        self.pos = _save
        break
      end
      @result = begin; a; end
      _tmp = true
      unless _tmp
        self.pos = _save
      end
      break
    end # end sequence

    set_failed_rule :_block_args unless _tmp
    return _tmp
  end

  # curly = p:p "{" - body?:b - "}" {b || body_nil}
  def _curly

    _save = self.pos
    while true # sequence
      _tmp = apply(:_p)
      p = @result
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = match_string("{")
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = apply(:__hyphen_)
      unless _tmp
        self.pos = _save
        break
      end
      _save1 = self.pos
      _tmp = apply(:_body)
      @result = nil unless _tmp
      unless _tmp
        _tmp = true
        self.pos = _save1
      end
      b = @result
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = apply(:__hyphen_)
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = match_string("}")
      unless _tmp
        self.pos = _save
        break
      end
      @result = begin; b || body_nil; end
      _tmp = true
      unless _tmp
        self.pos = _save
      end
      break
    end # end sequence

    set_failed_rule :_curly unless _tmp
    return _tmp
  end

  # block_params = (block_params:b space+ identifier:i {b + [i]} | identifier:i {[i]})
  def _block_params

    _save = self.pos
    while true # choice

      _save1 = self.pos
      while true # sequence
        _tmp = apply(:_block_params)
        b = @result
        unless _tmp
          self.pos = _save1
          break
        end
        _save2 = self.pos
        _tmp = apply(:_space)
        if _tmp
          while true
            _tmp = apply(:_space)
            break unless _tmp
          end
          _tmp = true
        else
          self.pos = _save2
        end
        unless _tmp
          self.pos = _save1
          break
        end
        _tmp = apply(:_identifier)
        i = @result
        unless _tmp
          self.pos = _save1
          break
        end
        @result = begin; b + [i]; end
        _tmp = true
        unless _tmp
          self.pos = _save1
        end
        break
      end # end sequence

      break if _tmp
      self.pos = _save

      _save3 = self.pos
      while true # sequence
        _tmp = apply(:_identifier)
        i = @result
        unless _tmp
          self.pos = _save3
          break
        end
        @result = begin; [i]; end
        _tmp = true
        unless _tmp
          self.pos = _save3
        end
        break
      end # end sequence

      break if _tmp
      self.pos = _save
      break
    end # end choice

    set_failed_rule :_block_params unless _tmp
    return _tmp
  end

  # return_expr = p:p "return" noident (space+ chain:c)? {node(p, :return, c)}
  def _return_expr

    _save = self.pos
    while true # sequence
      _tmp = apply(:_p)
      p = @result
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = match_string("return")
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = apply(:_noident)
      unless _tmp
        self.pos = _save
        break
      end
      _save1 = self.pos

      _save2 = self.pos
      while true # sequence
        _save3 = self.pos
        _tmp = apply(:_space)
        if _tmp
          while true
            _tmp = apply(:_space)
            break unless _tmp
          end
          _tmp = true
        else
          self.pos = _save3
        end
        unless _tmp
          self.pos = _save2
          break
        end
        _tmp = apply(:_chain)
        c = @result
        unless _tmp
          self.pos = _save2
        end
        break
      end # end sequence

      unless _tmp
        _tmp = true
        self.pos = _save1
      end
      unless _tmp
        self.pos = _save
        break
      end
      @result = begin; node(p, :return, c); end
      _tmp = true
      unless _tmp
        self.pos = _save
      end
      break
    end # end sequence

    set_failed_rule :_return_expr unless _tmp
    return _tmp
  end

  # return_local = p:p "return_local" noident (space+ chain:c)? {node(p, :return_local, c)}
  def _return_local

    _save = self.pos
    while true # sequence
      _tmp = apply(:_p)
      p = @result
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = match_string("return_local")
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = apply(:_noident)
      unless _tmp
        self.pos = _save
        break
      end
      _save1 = self.pos

      _save2 = self.pos
      while true # sequence
        _save3 = self.pos
        _tmp = apply(:_space)
        if _tmp
          while true
            _tmp = apply(:_space)
            break unless _tmp
          end
          _tmp = true
        else
          self.pos = _save3
        end
        unless _tmp
          self.pos = _save2
          break
        end
        _tmp = apply(:_chain)
        c = @result
        unless _tmp
          self.pos = _save2
        end
        break
      end # end sequence

      unless _tmp
        _tmp = true
        self.pos = _save1
      end
      unless _tmp
        self.pos = _save
        break
      end
      @result = begin; node(p, :return_local, c); end
      _tmp = true
      unless _tmp
        self.pos = _save
      end
      break
    end # end sequence

    set_failed_rule :_return_local unless _tmp
    return _tmp
  end

  # value = (return_expr | return_local | assignment | expr)
  def _value

    _save = self.pos
    while true # choice
      _tmp = apply(:_return_expr)
      break if _tmp
      self.pos = _save
      _tmp = apply(:_return_local)
      break if _tmp
      self.pos = _save
      _tmp = apply(:_assignment)
      break if _tmp
      self.pos = _save
      _tmp = apply(:_expr)
      break if _tmp
      self.pos = _save
      break
    end # end choice

    set_failed_rule :_value unless _tmp
    return _tmp
  end

  # name = (identifier | constant):n !(&(space* ":")) {n}
  def _name

    _save = self.pos
    while true # sequence

      _save1 = self.pos
      while true # choice
        _tmp = apply(:_identifier)
        break if _tmp
        self.pos = _save1
        _tmp = apply(:_constant)
        break if _tmp
        self.pos = _save1
        break
      end # end choice

      n = @result
      unless _tmp
        self.pos = _save
        break
      end
      _save2 = self.pos
      _save3 = self.pos

      _save4 = self.pos
      while true # sequence
        while true
          _tmp = apply(:_space)
          break unless _tmp
        end
        _tmp = true
        unless _tmp
          self.pos = _save4
          break
        end
        _tmp = match_string(":")
        unless _tmp
          self.pos = _save4
        end
        break
      end # end sequence

      self.pos = _save3
      _tmp = _tmp ? nil : true
      self.pos = _save2
      unless _tmp
        self.pos = _save
        break
      end
      @result = begin; n; end
      _tmp = true
      unless _tmp
        self.pos = _save
      end
      break
    end # end sequence

    set_failed_rule :_name unless _tmp
    return _tmp
  end

  # eq = "=" (space | nl | comment)
  def _eq

    _save = self.pos
    while true # sequence
      _tmp = match_string("=")
      unless _tmp
        self.pos = _save
        break
      end

      _save1 = self.pos
      while true # choice
        _tmp = apply(:_space)
        break if _tmp
        self.pos = _save1
        _tmp = apply(:_nl)
        break if _tmp
        self.pos = _save1
        _tmp = apply(:_comment)
        break if _tmp
        self.pos = _save1
        break
      end # end choice

      unless _tmp
        self.pos = _save
      end
      break
    end # end sequence

    set_failed_rule :_eq unless _tmp
    return _tmp
  end

  # assignment = (p:p tuple_items(&name):a space+ eq - (tuple_items(&chain) | chain:c {[c]}):b {node(p, :massign, a, b)} | p:p name:a space+ eq - chain:b {node(p, :assign, a, b)})
  def _assignment

    _save = self.pos
    while true # choice

      _save1 = self.pos
      while true # sequence
        _tmp = apply(:_p)
        p = @result
        unless _tmp
          self.pos = _save1
          break
        end
        _tmp = apply_with_args(:_tuple_items, (@refargs[1] ||= Proc.new {
          _tmp = apply(:_name)
          _tmp
        }))
        a = @result
        unless _tmp
          self.pos = _save1
          break
        end
        _save2 = self.pos
        _tmp = apply(:_space)
        if _tmp
          while true
            _tmp = apply(:_space)
            break unless _tmp
          end
          _tmp = true
        else
          self.pos = _save2
        end
        unless _tmp
          self.pos = _save1
          break
        end
        _tmp = apply(:_eq)
        unless _tmp
          self.pos = _save1
          break
        end
        _tmp = apply(:__hyphen_)
        unless _tmp
          self.pos = _save1
          break
        end

        _save3 = self.pos
        while true # choice
          _tmp = apply_with_args(:_tuple_items, (@refargs[2] ||= Proc.new {
            _tmp = apply(:_chain)
            _tmp
          }))
          break if _tmp
          self.pos = _save3

          _save4 = self.pos
          while true # sequence
            _tmp = apply(:_chain)
            c = @result
            unless _tmp
              self.pos = _save4
              break
            end
            @result = begin; [c]; end
            _tmp = true
            unless _tmp
              self.pos = _save4
            end
            break
          end # end sequence

          break if _tmp
          self.pos = _save3
          break
        end # end choice

        b = @result
        unless _tmp
          self.pos = _save1
          break
        end
        @result = begin; node(p, :massign, a, b); end
        _tmp = true
        unless _tmp
          self.pos = _save1
        end
        break
      end # end sequence

      break if _tmp
      self.pos = _save

      _save5 = self.pos
      while true # sequence
        _tmp = apply(:_p)
        p = @result
        unless _tmp
          self.pos = _save5
          break
        end
        _tmp = apply(:_name)
        a = @result
        unless _tmp
          self.pos = _save5
          break
        end
        _save6 = self.pos
        _tmp = apply(:_space)
        if _tmp
          while true
            _tmp = apply(:_space)
            break unless _tmp
          end
          _tmp = true
        else
          self.pos = _save6
        end
        unless _tmp
          self.pos = _save5
          break
        end
        _tmp = apply(:_eq)
        unless _tmp
          self.pos = _save5
          break
        end
        _tmp = apply(:__hyphen_)
        unless _tmp
          self.pos = _save5
          break
        end
        _tmp = apply(:_chain)
        b = @result
        unless _tmp
          self.pos = _save5
          break
        end
        @result = begin; node(p, :assign, a, b); end
        _tmp = true
        unless _tmp
          self.pos = _save5
        end
        break
      end # end sequence

      break if _tmp
      self.pos = _save
      break
    end # end choice

    set_failed_rule :_assignment unless _tmp
    return _tmp
  end

  # tuple = p:p "(" - tuple_items(&body):v - ")" {node(p, :tuple, *v)}
  def _tuple

    _save = self.pos
    while true # sequence
      _tmp = apply(:_p)
      p = @result
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = match_string("(")
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = apply(:__hyphen_)
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = apply_with_args(:_tuple_items, (@refargs[3] ||= Proc.new {
        _tmp = apply(:_body)
        _tmp
      }))
      v = @result
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = apply(:__hyphen_)
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = match_string(")")
      unless _tmp
        self.pos = _save
        break
      end
      @result = begin; node(p, :tuple, *v); end
      _tmp = true
      unless _tmp
        self.pos = _save
      end
      break
    end # end sequence

    set_failed_rule :_tuple unless _tmp
    return _tmp
  end

  # array = p:p "[" - maybe_items(&body):v - "]" {node(p, :array, *v)}
  def _array

    _save = self.pos
    while true # sequence
      _tmp = apply(:_p)
      p = @result
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = match_string("[")
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = apply(:__hyphen_)
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = apply_with_args(:_maybe_items, (@refargs[4] ||= Proc.new {
        _tmp = apply(:_body)
        _tmp
      }))
      v = @result
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = apply(:__hyphen_)
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = match_string("]")
      unless _tmp
        self.pos = _save
        break
      end
      @result = begin; node(p, :array, *v); end
      _tmp = true
      unless _tmp
        self.pos = _save
      end
      break
    end # end sequence

    set_failed_rule :_array unless _tmp
    return _tmp
  end

  # hash = p:p "<[" - maybe_items(&pair):v - "]>" {node(p, :hash, *v)}
  def _hash

    _save = self.pos
    while true # sequence
      _tmp = apply(:_p)
      p = @result
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = match_string("<[")
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = apply(:__hyphen_)
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = apply_with_args(:_maybe_items, (@refargs[5] ||= Proc.new {
        _tmp = apply(:_pair)
        _tmp
      }))
      v = @result
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = apply(:__hyphen_)
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = match_string("]>")
      unless _tmp
        self.pos = _save
        break
      end
      @result = begin; node(p, :hash, *v); end
      _tmp = true
      unless _tmp
        self.pos = _save
      end
      break
    end # end sequence

    set_failed_rule :_hash unless _tmp
    return _tmp
  end

  # pair = chain:a space+ "=>" space+ chain:b {[a, b]}
  def _pair

    _save = self.pos
    while true # sequence
      _tmp = apply(:_chain)
      a = @result
      unless _tmp
        self.pos = _save
        break
      end
      _save1 = self.pos
      _tmp = apply(:_space)
      if _tmp
        while true
          _tmp = apply(:_space)
          break unless _tmp
        end
        _tmp = true
      else
        self.pos = _save1
      end
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = match_string("=>")
      unless _tmp
        self.pos = _save
        break
      end
      _save2 = self.pos
      _tmp = apply(:_space)
      if _tmp
        while true
          _tmp = apply(:_space)
          break unless _tmp
        end
        _tmp = true
      else
        self.pos = _save2
      end
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = apply(:_chain)
      b = @result
      unless _tmp
        self.pos = _save
        break
      end
      @result = begin; [a, b]; end
      _tmp = true
      unless _tmp
        self.pos = _save
      end
      break
    end # end sequence

    set_failed_rule :_pair unless _tmp
    return _tmp
  end

  # range = p:p value:a space+ ".." space+ value:b {node(p, :range, a, b)}
  def _range

    _save = self.pos
    while true # sequence
      _tmp = apply(:_p)
      p = @result
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = apply(:_value)
      a = @result
      unless _tmp
        self.pos = _save
        break
      end
      _save1 = self.pos
      _tmp = apply(:_space)
      if _tmp
        while true
          _tmp = apply(:_space)
          break unless _tmp
        end
        _tmp = true
      else
        self.pos = _save1
      end
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = match_string("..")
      unless _tmp
        self.pos = _save
        break
      end
      _save2 = self.pos
      _tmp = apply(:_space)
      if _tmp
        while true
          _tmp = apply(:_space)
          break unless _tmp
        end
        _tmp = true
      else
        self.pos = _save2
      end
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = apply(:_value)
      b = @result
      unless _tmp
        self.pos = _save
        break
      end
      @result = begin; node(p, :range, a, b); end
      _tmp = true
      unless _tmp
        self.pos = _save
      end
      break
    end # end sequence

    set_failed_rule :_range unless _tmp
    return _tmp
  end

  # expr = (tuple | array | hash | "(" - body:v - ")" {v} | "$" space+ chain:c {c} | classdef | methodef | match | trycatch | literal | block | ruby | special | name | message)
  def _expr

    _save = self.pos
    while true # choice
      _tmp = apply(:_tuple)
      break if _tmp
      self.pos = _save
      _tmp = apply(:_array)
      break if _tmp
      self.pos = _save
      _tmp = apply(:_hash)
      break if _tmp
      self.pos = _save

      _save1 = self.pos
      while true # sequence
        _tmp = match_string("(")
        unless _tmp
          self.pos = _save1
          break
        end
        _tmp = apply(:__hyphen_)
        unless _tmp
          self.pos = _save1
          break
        end
        _tmp = apply(:_body)
        v = @result
        unless _tmp
          self.pos = _save1
          break
        end
        _tmp = apply(:__hyphen_)
        unless _tmp
          self.pos = _save1
          break
        end
        _tmp = match_string(")")
        unless _tmp
          self.pos = _save1
          break
        end
        @result = begin; v; end
        _tmp = true
        unless _tmp
          self.pos = _save1
        end
        break
      end # end sequence

      break if _tmp
      self.pos = _save

      _save2 = self.pos
      while true # sequence
        _tmp = match_string("$")
        unless _tmp
          self.pos = _save2
          break
        end
        _save3 = self.pos
        _tmp = apply(:_space)
        if _tmp
          while true
            _tmp = apply(:_space)
            break unless _tmp
          end
          _tmp = true
        else
          self.pos = _save3
        end
        unless _tmp
          self.pos = _save2
          break
        end
        _tmp = apply(:_chain)
        c = @result
        unless _tmp
          self.pos = _save2
          break
        end
        @result = begin; c; end
        _tmp = true
        unless _tmp
          self.pos = _save2
        end
        break
      end # end sequence

      break if _tmp
      self.pos = _save
      _tmp = apply(:_classdef)
      break if _tmp
      self.pos = _save
      _tmp = apply(:_methodef)
      break if _tmp
      self.pos = _save
      _tmp = apply(:_match)
      break if _tmp
      self.pos = _save
      _tmp = apply(:_trycatch)
      break if _tmp
      self.pos = _save
      _tmp = apply(:_literal)
      break if _tmp
      self.pos = _save
      _tmp = apply(:_block)
      break if _tmp
      self.pos = _save
      _tmp = apply(:_ruby)
      break if _tmp
      self.pos = _save
      _tmp = apply(:_special)
      break if _tmp
      self.pos = _save
      _tmp = apply(:_name)
      break if _tmp
      self.pos = _save
      _tmp = apply(:_message)
      break if _tmp
      self.pos = _save
      break
    end # end choice

    set_failed_rule :_expr unless _tmp
    return _tmp
  end

  # maybe_items = t?:a (space* "," - t:o {o})*:n {[a,n].flatten.compact}
  def _maybe_items(t)

    _save = self.pos
    while true # sequence
      _save1 = self.pos
      _tmp = t.call()
      @result = nil unless _tmp
      unless _tmp
        _tmp = true
        self.pos = _save1
      end
      a = @result
      unless _tmp
        self.pos = _save
        break
      end
      _ary = []
      while true

        _save3 = self.pos
        while true # sequence
          while true
            _tmp = apply(:_space)
            break unless _tmp
          end
          _tmp = true
          unless _tmp
            self.pos = _save3
            break
          end
          _tmp = match_string(",")
          unless _tmp
            self.pos = _save3
            break
          end
          _tmp = apply(:__hyphen_)
          unless _tmp
            self.pos = _save3
            break
          end
          _tmp = t.call()
          o = @result
          unless _tmp
            self.pos = _save3
            break
          end
          @result = begin; o; end
          _tmp = true
          unless _tmp
            self.pos = _save3
          end
          break
        end # end sequence

        _ary << @result if _tmp
        break unless _tmp
      end
      _tmp = true
      @result = _ary
      n = @result
      unless _tmp
        self.pos = _save
        break
      end
      @result = begin; [a,n].flatten.compact; end
      _tmp = true
      unless _tmp
        self.pos = _save
      end
      break
    end # end sequence

    set_failed_rule :_maybe_items unless _tmp
    return _tmp
  end

  # tuple_items = t:a (space* "," - t:o {o})+:n {[a,n].flatten}
  def _tuple_items(t)

    _save = self.pos
    while true # sequence
      _tmp = t.call()
      a = @result
      unless _tmp
        self.pos = _save
        break
      end
      _save1 = self.pos
      _ary = []

      _save2 = self.pos
      while true # sequence
        while true
          _tmp = apply(:_space)
          break unless _tmp
        end
        _tmp = true
        unless _tmp
          self.pos = _save2
          break
        end
        _tmp = match_string(",")
        unless _tmp
          self.pos = _save2
          break
        end
        _tmp = apply(:__hyphen_)
        unless _tmp
          self.pos = _save2
          break
        end
        _tmp = t.call()
        o = @result
        unless _tmp
          self.pos = _save2
          break
        end
        @result = begin; o; end
        _tmp = true
        unless _tmp
          self.pos = _save2
        end
        break
      end # end sequence

      if _tmp
        _ary << @result
        while true

          _save4 = self.pos
          while true # sequence
            while true
              _tmp = apply(:_space)
              break unless _tmp
            end
            _tmp = true
            unless _tmp
              self.pos = _save4
              break
            end
            _tmp = match_string(",")
            unless _tmp
              self.pos = _save4
              break
            end
            _tmp = apply(:__hyphen_)
            unless _tmp
              self.pos = _save4
              break
            end
            _tmp = t.call()
            o = @result
            unless _tmp
              self.pos = _save4
              break
            end
            @result = begin; o; end
            _tmp = true
            unless _tmp
              self.pos = _save4
            end
            break
          end # end sequence

          _ary << @result if _tmp
          break unless _tmp
        end
        _tmp = true
        @result = _ary
      else
        self.pos = _save1
      end
      n = @result
      unless _tmp
        self.pos = _save
        break
      end
      @result = begin; [a,n].flatten; end
      _tmp = true
      unless _tmp
        self.pos = _save
      end
      break
    end # end sequence

    set_failed_rule :_tuple_items unless _tmp
    return _tmp
  end

  # trycatch = (p:p "try" space+ curly:t space+ ((catches | {[]}):c space+)? finally:f {node(p, :try, t, c, f)} | p:p "try" space+ curly:t space+ catches:c {node(p, :try, t, c)})
  def _trycatch

    _save = self.pos
    while true # choice

      _save1 = self.pos
      while true # sequence
        _tmp = apply(:_p)
        p = @result
        unless _tmp
          self.pos = _save1
          break
        end
        _tmp = match_string("try")
        unless _tmp
          self.pos = _save1
          break
        end
        _save2 = self.pos
        _tmp = apply(:_space)
        if _tmp
          while true
            _tmp = apply(:_space)
            break unless _tmp
          end
          _tmp = true
        else
          self.pos = _save2
        end
        unless _tmp
          self.pos = _save1
          break
        end
        _tmp = apply(:_curly)
        t = @result
        unless _tmp
          self.pos = _save1
          break
        end
        _save3 = self.pos
        _tmp = apply(:_space)
        if _tmp
          while true
            _tmp = apply(:_space)
            break unless _tmp
          end
          _tmp = true
        else
          self.pos = _save3
        end
        unless _tmp
          self.pos = _save1
          break
        end
        _save4 = self.pos

        _save5 = self.pos
        while true # sequence

          _save6 = self.pos
          while true # choice
            _tmp = apply(:_catches)
            break if _tmp
            self.pos = _save6
            @result = begin; []; end
            _tmp = true
            break if _tmp
            self.pos = _save6
            break
          end # end choice

          c = @result
          unless _tmp
            self.pos = _save5
            break
          end
          _save7 = self.pos
          _tmp = apply(:_space)
          if _tmp
            while true
              _tmp = apply(:_space)
              break unless _tmp
            end
            _tmp = true
          else
            self.pos = _save7
          end
          unless _tmp
            self.pos = _save5
          end
          break
        end # end sequence

        unless _tmp
          _tmp = true
          self.pos = _save4
        end
        unless _tmp
          self.pos = _save1
          break
        end
        _tmp = apply(:_finally)
        f = @result
        unless _tmp
          self.pos = _save1
          break
        end
        @result = begin; node(p, :try, t, c, f); end
        _tmp = true
        unless _tmp
          self.pos = _save1
        end
        break
      end # end sequence

      break if _tmp
      self.pos = _save

      _save8 = self.pos
      while true # sequence
        _tmp = apply(:_p)
        p = @result
        unless _tmp
          self.pos = _save8
          break
        end
        _tmp = match_string("try")
        unless _tmp
          self.pos = _save8
          break
        end
        _save9 = self.pos
        _tmp = apply(:_space)
        if _tmp
          while true
            _tmp = apply(:_space)
            break unless _tmp
          end
          _tmp = true
        else
          self.pos = _save9
        end
        unless _tmp
          self.pos = _save8
          break
        end
        _tmp = apply(:_curly)
        t = @result
        unless _tmp
          self.pos = _save8
          break
        end
        _save10 = self.pos
        _tmp = apply(:_space)
        if _tmp
          while true
            _tmp = apply(:_space)
            break unless _tmp
          end
          _tmp = true
        else
          self.pos = _save10
        end
        unless _tmp
          self.pos = _save8
          break
        end
        _tmp = apply(:_catches)
        c = @result
        unless _tmp
          self.pos = _save8
          break
        end
        @result = begin; node(p, :try, t, c); end
        _tmp = true
        unless _tmp
          self.pos = _save8
        end
        break
      end # end sequence

      break if _tmp
      self.pos = _save
      break
    end # end choice

    set_failed_rule :_trycatch unless _tmp
    return _tmp
  end

  # finally = p:p "finally" space+ curly:f {node(p, :finally, f)}
  def _finally

    _save = self.pos
    while true # sequence
      _tmp = apply(:_p)
      p = @result
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = match_string("finally")
      unless _tmp
        self.pos = _save
        break
      end
      _save1 = self.pos
      _tmp = apply(:_space)
      if _tmp
        while true
          _tmp = apply(:_space)
          break unless _tmp
        end
        _tmp = true
      else
        self.pos = _save1
      end
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = apply(:_curly)
      f = @result
      unless _tmp
        self.pos = _save
        break
      end
      @result = begin; node(p, :finally, f); end
      _tmp = true
      unless _tmp
        self.pos = _save
      end
      break
    end # end sequence

    set_failed_rule :_finally unless _tmp
    return _tmp
  end

  # catche = (p:p "catch" space+ curly:b {node(p, :catch, b, node(p, :const, "Object"))} | p:p "catch" space+ value:v space+ "=>" space+ identifier:i space+ curly:b {node(p, :catch, b, v, i)} | p:p "catch" space+ value:v space+ curly:b {node(p, :catch, b, v)})
  def _catche

    _save = self.pos
    while true # choice

      _save1 = self.pos
      while true # sequence
        _tmp = apply(:_p)
        p = @result
        unless _tmp
          self.pos = _save1
          break
        end
        _tmp = match_string("catch")
        unless _tmp
          self.pos = _save1
          break
        end
        _save2 = self.pos
        _tmp = apply(:_space)
        if _tmp
          while true
            _tmp = apply(:_space)
            break unless _tmp
          end
          _tmp = true
        else
          self.pos = _save2
        end
        unless _tmp
          self.pos = _save1
          break
        end
        _tmp = apply(:_curly)
        b = @result
        unless _tmp
          self.pos = _save1
          break
        end
        @result = begin; node(p, :catch, b, node(p, :const, "Object")); end
        _tmp = true
        unless _tmp
          self.pos = _save1
        end
        break
      end # end sequence

      break if _tmp
      self.pos = _save

      _save3 = self.pos
      while true # sequence
        _tmp = apply(:_p)
        p = @result
        unless _tmp
          self.pos = _save3
          break
        end
        _tmp = match_string("catch")
        unless _tmp
          self.pos = _save3
          break
        end
        _save4 = self.pos
        _tmp = apply(:_space)
        if _tmp
          while true
            _tmp = apply(:_space)
            break unless _tmp
          end
          _tmp = true
        else
          self.pos = _save4
        end
        unless _tmp
          self.pos = _save3
          break
        end
        _tmp = apply(:_value)
        v = @result
        unless _tmp
          self.pos = _save3
          break
        end
        _save5 = self.pos
        _tmp = apply(:_space)
        if _tmp
          while true
            _tmp = apply(:_space)
            break unless _tmp
          end
          _tmp = true
        else
          self.pos = _save5
        end
        unless _tmp
          self.pos = _save3
          break
        end
        _tmp = match_string("=>")
        unless _tmp
          self.pos = _save3
          break
        end
        _save6 = self.pos
        _tmp = apply(:_space)
        if _tmp
          while true
            _tmp = apply(:_space)
            break unless _tmp
          end
          _tmp = true
        else
          self.pos = _save6
        end
        unless _tmp
          self.pos = _save3
          break
        end
        _tmp = apply(:_identifier)
        i = @result
        unless _tmp
          self.pos = _save3
          break
        end
        _save7 = self.pos
        _tmp = apply(:_space)
        if _tmp
          while true
            _tmp = apply(:_space)
            break unless _tmp
          end
          _tmp = true
        else
          self.pos = _save7
        end
        unless _tmp
          self.pos = _save3
          break
        end
        _tmp = apply(:_curly)
        b = @result
        unless _tmp
          self.pos = _save3
          break
        end
        @result = begin; node(p, :catch, b, v, i); end
        _tmp = true
        unless _tmp
          self.pos = _save3
        end
        break
      end # end sequence

      break if _tmp
      self.pos = _save

      _save8 = self.pos
      while true # sequence
        _tmp = apply(:_p)
        p = @result
        unless _tmp
          self.pos = _save8
          break
        end
        _tmp = match_string("catch")
        unless _tmp
          self.pos = _save8
          break
        end
        _save9 = self.pos
        _tmp = apply(:_space)
        if _tmp
          while true
            _tmp = apply(:_space)
            break unless _tmp
          end
          _tmp = true
        else
          self.pos = _save9
        end
        unless _tmp
          self.pos = _save8
          break
        end
        _tmp = apply(:_value)
        v = @result
        unless _tmp
          self.pos = _save8
          break
        end
        _save10 = self.pos
        _tmp = apply(:_space)
        if _tmp
          while true
            _tmp = apply(:_space)
            break unless _tmp
          end
          _tmp = true
        else
          self.pos = _save10
        end
        unless _tmp
          self.pos = _save8
          break
        end
        _tmp = apply(:_curly)
        b = @result
        unless _tmp
          self.pos = _save8
          break
        end
        @result = begin; node(p, :catch, b, v); end
        _tmp = true
        unless _tmp
          self.pos = _save8
        end
        break
      end # end sequence

      break if _tmp
      self.pos = _save
      break
    end # end choice

    set_failed_rule :_catche unless _tmp
    return _tmp
  end

  # catches = (catches:s space+ catche:c {s+[c]} | catche:c {[c]})
  def _catches

    _save = self.pos
    while true # choice

      _save1 = self.pos
      while true # sequence
        _tmp = apply(:_catches)
        s = @result
        unless _tmp
          self.pos = _save1
          break
        end
        _save2 = self.pos
        _tmp = apply(:_space)
        if _tmp
          while true
            _tmp = apply(:_space)
            break unless _tmp
          end
          _tmp = true
        else
          self.pos = _save2
        end
        unless _tmp
          self.pos = _save1
          break
        end
        _tmp = apply(:_catche)
        c = @result
        unless _tmp
          self.pos = _save1
          break
        end
        @result = begin; s+[c]; end
        _tmp = true
        unless _tmp
          self.pos = _save1
        end
        break
      end # end sequence

      break if _tmp
      self.pos = _save

      _save3 = self.pos
      while true # sequence
        _tmp = apply(:_catche)
        c = @result
        unless _tmp
          self.pos = _save3
          break
        end
        @result = begin; [c]; end
        _tmp = true
        unless _tmp
          self.pos = _save3
        end
        break
      end # end sequence

      break if _tmp
      self.pos = _save
      break
    end # end choice

    set_failed_rule :_catches unless _tmp
    return _tmp
  end

  # match = p:p "match" space+ chain:v space+ "{" - match_cases:c - "}" {node(p, :match, v, *c)}
  def _match

    _save = self.pos
    while true # sequence
      _tmp = apply(:_p)
      p = @result
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = match_string("match")
      unless _tmp
        self.pos = _save
        break
      end
      _save1 = self.pos
      _tmp = apply(:_space)
      if _tmp
        while true
          _tmp = apply(:_space)
          break unless _tmp
        end
        _tmp = true
      else
        self.pos = _save1
      end
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = apply(:_chain)
      v = @result
      unless _tmp
        self.pos = _save
        break
      end
      _save2 = self.pos
      _tmp = apply(:_space)
      if _tmp
        while true
          _tmp = apply(:_space)
          break unless _tmp
        end
        _tmp = true
      else
        self.pos = _save2
      end
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = match_string("{")
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = apply(:__hyphen_)
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = apply(:_match_cases)
      c = @result
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = apply(:__hyphen_)
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = match_string("}")
      unless _tmp
        self.pos = _save
        break
      end
      @result = begin; node(p, :match, v, *c); end
      _tmp = true
      unless _tmp
        self.pos = _save
      end
      break
    end # end sequence

    set_failed_rule :_match unless _tmp
    return _tmp
  end

  # match_cases = (match_cases:s - match_case:c {s + [c]} | match_case:c {[c]})
  def _match_cases

    _save = self.pos
    while true # choice

      _save1 = self.pos
      while true # sequence
        _tmp = apply(:_match_cases)
        s = @result
        unless _tmp
          self.pos = _save1
          break
        end
        _tmp = apply(:__hyphen_)
        unless _tmp
          self.pos = _save1
          break
        end
        _tmp = apply(:_match_case)
        c = @result
        unless _tmp
          self.pos = _save1
          break
        end
        @result = begin; s + [c]; end
        _tmp = true
        unless _tmp
          self.pos = _save1
        end
        break
      end # end sequence

      break if _tmp
      self.pos = _save

      _save2 = self.pos
      while true # sequence
        _tmp = apply(:_match_case)
        c = @result
        unless _tmp
          self.pos = _save2
          break
        end
        @result = begin; [c]; end
        _tmp = true
        unless _tmp
          self.pos = _save2
        end
        break
      end # end sequence

      break if _tmp
      self.pos = _save
      break
    end # end choice

    set_failed_rule :_match_cases unless _tmp
    return _tmp
  end

  # match_case = (p:p "case" space+ value:v space+ "->" space+ block_args:a - body:b {node(p, :case, v, a, b)} | p:p "case" space+ value:v space+ "->" - body:b {node(p, :case, v, [], b)})
  def _match_case

    _save = self.pos
    while true # choice

      _save1 = self.pos
      while true # sequence
        _tmp = apply(:_p)
        p = @result
        unless _tmp
          self.pos = _save1
          break
        end
        _tmp = match_string("case")
        unless _tmp
          self.pos = _save1
          break
        end
        _save2 = self.pos
        _tmp = apply(:_space)
        if _tmp
          while true
            _tmp = apply(:_space)
            break unless _tmp
          end
          _tmp = true
        else
          self.pos = _save2
        end
        unless _tmp
          self.pos = _save1
          break
        end
        _tmp = apply(:_value)
        v = @result
        unless _tmp
          self.pos = _save1
          break
        end
        _save3 = self.pos
        _tmp = apply(:_space)
        if _tmp
          while true
            _tmp = apply(:_space)
            break unless _tmp
          end
          _tmp = true
        else
          self.pos = _save3
        end
        unless _tmp
          self.pos = _save1
          break
        end
        _tmp = match_string("->")
        unless _tmp
          self.pos = _save1
          break
        end
        _save4 = self.pos
        _tmp = apply(:_space)
        if _tmp
          while true
            _tmp = apply(:_space)
            break unless _tmp
          end
          _tmp = true
        else
          self.pos = _save4
        end
        unless _tmp
          self.pos = _save1
          break
        end
        _tmp = apply(:_block_args)
        a = @result
        unless _tmp
          self.pos = _save1
          break
        end
        _tmp = apply(:__hyphen_)
        unless _tmp
          self.pos = _save1
          break
        end
        _tmp = apply(:_body)
        b = @result
        unless _tmp
          self.pos = _save1
          break
        end
        @result = begin; node(p, :case, v, a, b); end
        _tmp = true
        unless _tmp
          self.pos = _save1
        end
        break
      end # end sequence

      break if _tmp
      self.pos = _save

      _save5 = self.pos
      while true # sequence
        _tmp = apply(:_p)
        p = @result
        unless _tmp
          self.pos = _save5
          break
        end
        _tmp = match_string("case")
        unless _tmp
          self.pos = _save5
          break
        end
        _save6 = self.pos
        _tmp = apply(:_space)
        if _tmp
          while true
            _tmp = apply(:_space)
            break unless _tmp
          end
          _tmp = true
        else
          self.pos = _save6
        end
        unless _tmp
          self.pos = _save5
          break
        end
        _tmp = apply(:_value)
        v = @result
        unless _tmp
          self.pos = _save5
          break
        end
        _save7 = self.pos
        _tmp = apply(:_space)
        if _tmp
          while true
            _tmp = apply(:_space)
            break unless _tmp
          end
          _tmp = true
        else
          self.pos = _save7
        end
        unless _tmp
          self.pos = _save5
          break
        end
        _tmp = match_string("->")
        unless _tmp
          self.pos = _save5
          break
        end
        _tmp = apply(:__hyphen_)
        unless _tmp
          self.pos = _save5
          break
        end
        _tmp = apply(:_body)
        b = @result
        unless _tmp
          self.pos = _save5
          break
        end
        @result = begin; node(p, :case, v, [], b); end
        _tmp = true
        unless _tmp
          self.pos = _save5
        end
        break
      end # end sequence

      break if _tmp
      self.pos = _save
      break
    end # end choice

    set_failed_rule :_match_case unless _tmp
    return _tmp
  end

  # classdef = p:p "class" space+ constant:c space+ (":" space+ constant:s space+)? curly:b {node(p, :class, c, s, b)}
  def _classdef

    _save = self.pos
    while true # sequence
      _tmp = apply(:_p)
      p = @result
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = match_string("class")
      unless _tmp
        self.pos = _save
        break
      end
      _save1 = self.pos
      _tmp = apply(:_space)
      if _tmp
        while true
          _tmp = apply(:_space)
          break unless _tmp
        end
        _tmp = true
      else
        self.pos = _save1
      end
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = apply(:_constant)
      c = @result
      unless _tmp
        self.pos = _save
        break
      end
      _save2 = self.pos
      _tmp = apply(:_space)
      if _tmp
        while true
          _tmp = apply(:_space)
          break unless _tmp
        end
        _tmp = true
      else
        self.pos = _save2
      end
      unless _tmp
        self.pos = _save
        break
      end
      _save3 = self.pos

      _save4 = self.pos
      while true # sequence
        _tmp = match_string(":")
        unless _tmp
          self.pos = _save4
          break
        end
        _save5 = self.pos
        _tmp = apply(:_space)
        if _tmp
          while true
            _tmp = apply(:_space)
            break unless _tmp
          end
          _tmp = true
        else
          self.pos = _save5
        end
        unless _tmp
          self.pos = _save4
          break
        end
        _tmp = apply(:_constant)
        s = @result
        unless _tmp
          self.pos = _save4
          break
        end
        _save6 = self.pos
        _tmp = apply(:_space)
        if _tmp
          while true
            _tmp = apply(:_space)
            break unless _tmp
          end
          _tmp = true
        else
          self.pos = _save6
        end
        unless _tmp
          self.pos = _save4
        end
        break
      end # end sequence

      unless _tmp
        _tmp = true
        self.pos = _save3
      end
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = apply(:_curly)
      b = @result
      unless _tmp
        self.pos = _save
        break
      end
      @result = begin; node(p, :class, c, s, b); end
      _tmp = true
      unless _tmp
        self.pos = _save
      end
      break
    end # end sequence

    set_failed_rule :_classdef unless _tmp
    return _tmp
  end

  # opdef = ("[" space* ident:i space* "]:" space+ ident:k space+ curly:b {["[]", i, k, b]} | "[" space* ident:i space* "]" space+ curly:b {["[]", i,b]} | oper:o space+ ident:i space+ curly:b {[o, i, b]})
  def _opdef

    _save = self.pos
    while true # choice

      _save1 = self.pos
      while true # sequence
        _tmp = match_string("[")
        unless _tmp
          self.pos = _save1
          break
        end
        while true
          _tmp = apply(:_space)
          break unless _tmp
        end
        _tmp = true
        unless _tmp
          self.pos = _save1
          break
        end
        _tmp = apply(:_ident)
        i = @result
        unless _tmp
          self.pos = _save1
          break
        end
        while true
          _tmp = apply(:_space)
          break unless _tmp
        end
        _tmp = true
        unless _tmp
          self.pos = _save1
          break
        end
        _tmp = match_string("]:")
        unless _tmp
          self.pos = _save1
          break
        end
        _save4 = self.pos
        _tmp = apply(:_space)
        if _tmp
          while true
            _tmp = apply(:_space)
            break unless _tmp
          end
          _tmp = true
        else
          self.pos = _save4
        end
        unless _tmp
          self.pos = _save1
          break
        end
        _tmp = apply(:_ident)
        k = @result
        unless _tmp
          self.pos = _save1
          break
        end
        _save5 = self.pos
        _tmp = apply(:_space)
        if _tmp
          while true
            _tmp = apply(:_space)
            break unless _tmp
          end
          _tmp = true
        else
          self.pos = _save5
        end
        unless _tmp
          self.pos = _save1
          break
        end
        _tmp = apply(:_curly)
        b = @result
        unless _tmp
          self.pos = _save1
          break
        end
        @result = begin; ["[]", i, k, b]; end
        _tmp = true
        unless _tmp
          self.pos = _save1
        end
        break
      end # end sequence

      break if _tmp
      self.pos = _save

      _save6 = self.pos
      while true # sequence
        _tmp = match_string("[")
        unless _tmp
          self.pos = _save6
          break
        end
        while true
          _tmp = apply(:_space)
          break unless _tmp
        end
        _tmp = true
        unless _tmp
          self.pos = _save6
          break
        end
        _tmp = apply(:_ident)
        i = @result
        unless _tmp
          self.pos = _save6
          break
        end
        while true
          _tmp = apply(:_space)
          break unless _tmp
        end
        _tmp = true
        unless _tmp
          self.pos = _save6
          break
        end
        _tmp = match_string("]")
        unless _tmp
          self.pos = _save6
          break
        end
        _save9 = self.pos
        _tmp = apply(:_space)
        if _tmp
          while true
            _tmp = apply(:_space)
            break unless _tmp
          end
          _tmp = true
        else
          self.pos = _save9
        end
        unless _tmp
          self.pos = _save6
          break
        end
        _tmp = apply(:_curly)
        b = @result
        unless _tmp
          self.pos = _save6
          break
        end
        @result = begin; ["[]", i,b]; end
        _tmp = true
        unless _tmp
          self.pos = _save6
        end
        break
      end # end sequence

      break if _tmp
      self.pos = _save

      _save10 = self.pos
      while true # sequence
        _tmp = apply(:_oper)
        o = @result
        unless _tmp
          self.pos = _save10
          break
        end
        _save11 = self.pos
        _tmp = apply(:_space)
        if _tmp
          while true
            _tmp = apply(:_space)
            break unless _tmp
          end
          _tmp = true
        else
          self.pos = _save11
        end
        unless _tmp
          self.pos = _save10
          break
        end
        _tmp = apply(:_ident)
        i = @result
        unless _tmp
          self.pos = _save10
          break
        end
        _save12 = self.pos
        _tmp = apply(:_space)
        if _tmp
          while true
            _tmp = apply(:_space)
            break unless _tmp
          end
          _tmp = true
        else
          self.pos = _save12
        end
        unless _tmp
          self.pos = _save10
          break
        end
        _tmp = apply(:_curly)
        b = @result
        unless _tmp
          self.pos = _save10
          break
        end
        @result = begin; [o, i, b]; end
        _tmp = true
        unless _tmp
          self.pos = _save10
        end
        break
      end # end sequence

      break if _tmp
      self.pos = _save
      break
    end # end choice

    set_failed_rule :_opdef unless _tmp
    return _tmp
  end

  # methodef = (methdef | operdef | smethdef | soperdef)
  def _methodef

    _save = self.pos
    while true # choice
      _tmp = apply(:_methdef)
      break if _tmp
      self.pos = _save
      _tmp = apply(:_operdef)
      break if _tmp
      self.pos = _save
      _tmp = apply(:_smethdef)
      break if _tmp
      self.pos = _save
      _tmp = apply(:_soperdef)
      break if _tmp
      self.pos = _save
      break
    end # end choice

    set_failed_rule :_methodef unless _tmp
    return _tmp
  end

  # operdef = p:p "def" space+ opdef:a {node(p, :oper, *a)}
  def _operdef

    _save = self.pos
    while true # sequence
      _tmp = apply(:_p)
      p = @result
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = match_string("def")
      unless _tmp
        self.pos = _save
        break
      end
      _save1 = self.pos
      _tmp = apply(:_space)
      if _tmp
        while true
          _tmp = apply(:_space)
          break unless _tmp
        end
        _tmp = true
      else
        self.pos = _save1
      end
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = apply(:_opdef)
      a = @result
      unless _tmp
        self.pos = _save
        break
      end
      @result = begin; node(p, :oper, *a); end
      _tmp = true
      unless _tmp
        self.pos = _save
      end
      break
    end # end sequence

    set_failed_rule :_operdef unless _tmp
    return _tmp
  end

  # soperdef = p:p "def" space+ value:v space+ opdef:a {node(p, :soper, v, *a)}
  def _soperdef

    _save = self.pos
    while true # sequence
      _tmp = apply(:_p)
      p = @result
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = match_string("def")
      unless _tmp
        self.pos = _save
        break
      end
      _save1 = self.pos
      _tmp = apply(:_space)
      if _tmp
        while true
          _tmp = apply(:_space)
          break unless _tmp
        end
        _tmp = true
      else
        self.pos = _save1
      end
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = apply(:_value)
      v = @result
      unless _tmp
        self.pos = _save
        break
      end
      _save2 = self.pos
      _tmp = apply(:_space)
      if _tmp
        while true
          _tmp = apply(:_space)
          break unless _tmp
        end
        _tmp = true
      else
        self.pos = _save2
      end
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = apply(:_opdef)
      a = @result
      unless _tmp
        self.pos = _save
        break
      end
      @result = begin; node(p, :soper, v, *a); end
      _tmp = true
      unless _tmp
        self.pos = _save
      end
      break
    end # end sequence

    set_failed_rule :_soperdef unless _tmp
    return _tmp
  end

  # methdef = p:p "def" space+ params:m (space+ curly | space* &(nl | comment) {body_nil}):b {node(p, :method, m, b)}
  def _methdef

    _save = self.pos
    while true # sequence
      _tmp = apply(:_p)
      p = @result
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = match_string("def")
      unless _tmp
        self.pos = _save
        break
      end
      _save1 = self.pos
      _tmp = apply(:_space)
      if _tmp
        while true
          _tmp = apply(:_space)
          break unless _tmp
        end
        _tmp = true
      else
        self.pos = _save1
      end
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = apply(:_params)
      m = @result
      unless _tmp
        self.pos = _save
        break
      end

      _save2 = self.pos
      while true # choice

        _save3 = self.pos
        while true # sequence
          _save4 = self.pos
          _tmp = apply(:_space)
          if _tmp
            while true
              _tmp = apply(:_space)
              break unless _tmp
            end
            _tmp = true
          else
            self.pos = _save4
          end
          unless _tmp
            self.pos = _save3
            break
          end
          _tmp = apply(:_curly)
          unless _tmp
            self.pos = _save3
          end
          break
        end # end sequence

        break if _tmp
        self.pos = _save2

        _save5 = self.pos
        while true # sequence
          while true
            _tmp = apply(:_space)
            break unless _tmp
          end
          _tmp = true
          unless _tmp
            self.pos = _save5
            break
          end
          _save7 = self.pos

          _save8 = self.pos
          while true # choice
            _tmp = apply(:_nl)
            break if _tmp
            self.pos = _save8
            _tmp = apply(:_comment)
            break if _tmp
            self.pos = _save8
            break
          end # end choice

          self.pos = _save7
          unless _tmp
            self.pos = _save5
            break
          end
          @result = begin; body_nil; end
          _tmp = true
          unless _tmp
            self.pos = _save5
          end
          break
        end # end sequence

        break if _tmp
        self.pos = _save2
        break
      end # end choice

      b = @result
      unless _tmp
        self.pos = _save
        break
      end
      @result = begin; node(p, :method, m, b); end
      _tmp = true
      unless _tmp
        self.pos = _save
      end
      break
    end # end sequence

    set_failed_rule :_methdef unless _tmp
    return _tmp
  end

  # smethdef = p:p "def" space+ value:v space+ params:m (space+ curly | space* &(nl | comment) {body_nil}):b {node(p, :smethod, v, m, b)}
  def _smethdef

    _save = self.pos
    while true # sequence
      _tmp = apply(:_p)
      p = @result
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = match_string("def")
      unless _tmp
        self.pos = _save
        break
      end
      _save1 = self.pos
      _tmp = apply(:_space)
      if _tmp
        while true
          _tmp = apply(:_space)
          break unless _tmp
        end
        _tmp = true
      else
        self.pos = _save1
      end
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = apply(:_value)
      v = @result
      unless _tmp
        self.pos = _save
        break
      end
      _save2 = self.pos
      _tmp = apply(:_space)
      if _tmp
        while true
          _tmp = apply(:_space)
          break unless _tmp
        end
        _tmp = true
      else
        self.pos = _save2
      end
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = apply(:_params)
      m = @result
      unless _tmp
        self.pos = _save
        break
      end

      _save3 = self.pos
      while true # choice

        _save4 = self.pos
        while true # sequence
          _save5 = self.pos
          _tmp = apply(:_space)
          if _tmp
            while true
              _tmp = apply(:_space)
              break unless _tmp
            end
            _tmp = true
          else
            self.pos = _save5
          end
          unless _tmp
            self.pos = _save4
            break
          end
          _tmp = apply(:_curly)
          unless _tmp
            self.pos = _save4
          end
          break
        end # end sequence

        break if _tmp
        self.pos = _save3

        _save6 = self.pos
        while true # sequence
          while true
            _tmp = apply(:_space)
            break unless _tmp
          end
          _tmp = true
          unless _tmp
            self.pos = _save6
            break
          end
          _save8 = self.pos

          _save9 = self.pos
          while true # choice
            _tmp = apply(:_nl)
            break if _tmp
            self.pos = _save9
            _tmp = apply(:_comment)
            break if _tmp
            self.pos = _save9
            break
          end # end choice

          self.pos = _save8
          unless _tmp
            self.pos = _save6
            break
          end
          @result = begin; body_nil; end
          _tmp = true
          unless _tmp
            self.pos = _save6
          end
          break
        end # end sequence

        break if _tmp
        self.pos = _save3
        break
      end # end choice

      b = @result
      unless _tmp
        self.pos = _save
        break
      end
      @result = begin; node(p, :smethod, v, m, b); end
      _tmp = true
      unless _tmp
        self.pos = _save
      end
      break
    end # end sequence

    set_failed_rule :_smethdef unless _tmp
    return _tmp
  end

  # params = (selectors:s {s} | p:p ident:i {node(p, :param, [i])})
  def _params

    _save = self.pos
    while true # choice

      _save1 = self.pos
      while true # sequence
        _tmp = apply(:_selectors)
        s = @result
        unless _tmp
          self.pos = _save1
          break
        end
        @result = begin; s; end
        _tmp = true
        unless _tmp
          self.pos = _save1
        end
        break
      end # end sequence

      break if _tmp
      self.pos = _save

      _save2 = self.pos
      while true # sequence
        _tmp = apply(:_p)
        p = @result
        unless _tmp
          self.pos = _save2
          break
        end
        _tmp = apply(:_ident)
        i = @result
        unless _tmp
          self.pos = _save2
          break
        end
        @result = begin; node(p, :param, [i]); end
        _tmp = true
        unless _tmp
          self.pos = _save2
        end
        break
      end # end sequence

      break if _tmp
      self.pos = _save
      break
    end # end choice

    set_failed_rule :_params unless _tmp
    return _tmp
  end

  # param = (p:p ident:i space+ "(" body:b ")" {[i, b]} | p:p ident:i {[i]})
  def _param

    _save = self.pos
    while true # choice

      _save1 = self.pos
      while true # sequence
        _tmp = apply(:_p)
        p = @result
        unless _tmp
          self.pos = _save1
          break
        end
        _tmp = apply(:_ident)
        i = @result
        unless _tmp
          self.pos = _save1
          break
        end
        _save2 = self.pos
        _tmp = apply(:_space)
        if _tmp
          while true
            _tmp = apply(:_space)
            break unless _tmp
          end
          _tmp = true
        else
          self.pos = _save2
        end
        unless _tmp
          self.pos = _save1
          break
        end
        _tmp = match_string("(")
        unless _tmp
          self.pos = _save1
          break
        end
        _tmp = apply(:_body)
        b = @result
        unless _tmp
          self.pos = _save1
          break
        end
        _tmp = match_string(")")
        unless _tmp
          self.pos = _save1
          break
        end
        @result = begin; [i, b]; end
        _tmp = true
        unless _tmp
          self.pos = _save1
        end
        break
      end # end sequence

      break if _tmp
      self.pos = _save

      _save3 = self.pos
      while true # sequence
        _tmp = apply(:_p)
        p = @result
        unless _tmp
          self.pos = _save3
          break
        end
        _tmp = apply(:_ident)
        i = @result
        unless _tmp
          self.pos = _save3
          break
        end
        @result = begin; [i]; end
        _tmp = true
        unless _tmp
          self.pos = _save3
        end
        break
      end # end sequence

      break if _tmp
      self.pos = _save
      break
    end # end choice

    set_failed_rule :_param unless _tmp
    return _tmp
  end

  # selectors = (selectors:s space+ ident:i ":" space+ param:a { s.args.push [i]+a; s } | p:p ident:i ":" space+ param:a {node(p, :param, [i]+a)})
  def _selectors

    _save = self.pos
    while true # choice

      _save1 = self.pos
      while true # sequence
        _tmp = apply(:_selectors)
        s = @result
        unless _tmp
          self.pos = _save1
          break
        end
        _save2 = self.pos
        _tmp = apply(:_space)
        if _tmp
          while true
            _tmp = apply(:_space)
            break unless _tmp
          end
          _tmp = true
        else
          self.pos = _save2
        end
        unless _tmp
          self.pos = _save1
          break
        end
        _tmp = apply(:_ident)
        i = @result
        unless _tmp
          self.pos = _save1
          break
        end
        _tmp = match_string(":")
        unless _tmp
          self.pos = _save1
          break
        end
        _save3 = self.pos
        _tmp = apply(:_space)
        if _tmp
          while true
            _tmp = apply(:_space)
            break unless _tmp
          end
          _tmp = true
        else
          self.pos = _save3
        end
        unless _tmp
          self.pos = _save1
          break
        end
        _tmp = apply(:_param)
        a = @result
        unless _tmp
          self.pos = _save1
          break
        end
        @result = begin;  s.args.push [i]+a; s ; end
        _tmp = true
        unless _tmp
          self.pos = _save1
        end
        break
      end # end sequence

      break if _tmp
      self.pos = _save

      _save4 = self.pos
      while true # sequence
        _tmp = apply(:_p)
        p = @result
        unless _tmp
          self.pos = _save4
          break
        end
        _tmp = apply(:_ident)
        i = @result
        unless _tmp
          self.pos = _save4
          break
        end
        _tmp = match_string(":")
        unless _tmp
          self.pos = _save4
          break
        end
        _save5 = self.pos
        _tmp = apply(:_space)
        if _tmp
          while true
            _tmp = apply(:_space)
            break unless _tmp
          end
          _tmp = true
        else
          self.pos = _save5
        end
        unless _tmp
          self.pos = _save4
          break
        end
        _tmp = apply(:_param)
        a = @result
        unless _tmp
          self.pos = _save4
          break
        end
        @result = begin; node(p, :param, [i]+a); end
        _tmp = true
        unless _tmp
          self.pos = _save4
        end
        break
      end # end sequence

      break if _tmp
      self.pos = _save
      break
    end # end choice

    set_failed_rule :_selectors unless _tmp
    return _tmp
  end

  # const = < /[A-Z][a-zA-Z0-9_]*/ > {text}
  def _const

    _save = self.pos
    while true # sequence
      _text_start = self.pos
      _tmp = scan(/\A(?-mix:[A-Z][a-zA-Z0-9_]*)/)
      if _tmp
        text = get_text(_text_start)
      end
      unless _tmp
        self.pos = _save
        break
      end
      @result = begin; text; end
      _tmp = true
      unless _tmp
        self.pos = _save
      end
      break
    end # end sequence

    set_failed_rule :_const unless _tmp
    return _tmp
  end

  # ident = < "@"? "@"? /[a-z_][a-zA-Z0-9_\?\!]*/ > &{ident?(text)} {text}
  def _ident

    _save = self.pos
    while true # sequence
      _text_start = self.pos

      _save1 = self.pos
      while true # sequence
        _save2 = self.pos
        _tmp = match_string("@")
        unless _tmp
          _tmp = true
          self.pos = _save2
        end
        unless _tmp
          self.pos = _save1
          break
        end
        _save3 = self.pos
        _tmp = match_string("@")
        unless _tmp
          _tmp = true
          self.pos = _save3
        end
        unless _tmp
          self.pos = _save1
          break
        end
        _tmp = scan(/\A(?-mix:[a-z_][a-zA-Z0-9_\?\!]*)/)
        unless _tmp
          self.pos = _save1
        end
        break
      end # end sequence

      if _tmp
        text = get_text(_text_start)
      end
      unless _tmp
        self.pos = _save
        break
      end
      _save4 = self.pos
      _tmp = begin; ident?(text); end
      self.pos = _save4
      unless _tmp
        self.pos = _save
        break
      end
      @result = begin; text; end
      _tmp = true
      unless _tmp
        self.pos = _save
      end
      break
    end # end sequence

    set_failed_rule :_ident unless _tmp
    return _tmp
  end

  # oper = < (/[?!=*\/^><%&~+-]+/ | "||" /[?!=*\/^><%&~+_-]*/) > &{oper?(text)} {text}
  def _oper

    _save = self.pos
    while true # sequence
      _text_start = self.pos

      _save1 = self.pos
      while true # choice
        _tmp = scan(/\A(?-mix:[?!=*\/^><%&~+-]+)/)
        break if _tmp
        self.pos = _save1

        _save2 = self.pos
        while true # sequence
          _tmp = match_string("||")
          unless _tmp
            self.pos = _save2
            break
          end
          _tmp = scan(/\A(?-mix:[?!=*\/^><%&~+_-]*)/)
          unless _tmp
            self.pos = _save2
          end
          break
        end # end sequence

        break if _tmp
        self.pos = _save1
        break
      end # end choice

      if _tmp
        text = get_text(_text_start)
      end
      unless _tmp
        self.pos = _save
        break
      end
      _save3 = self.pos
      _tmp = begin; oper?(text); end
      self.pos = _save3
      unless _tmp
        self.pos = _save
        break
      end
      @result = begin; text; end
      _tmp = true
      unless _tmp
        self.pos = _save
      end
      break
    end # end sequence

    set_failed_rule :_oper unless _tmp
    return _tmp
  end

  # noident = !(&/[a-zA-Z0-9_\?\!]/)
  def _noident
    _save = self.pos
    _save1 = self.pos
    _tmp = scan(/\A(?-mix:[a-zA-Z0-9_\?\!])/)
    self.pos = _save1
    _tmp = _tmp ? nil : true
    self.pos = _save
    set_failed_rule :_noident unless _tmp
    return _tmp
  end

  # special = p:p < ("self" | "nil" | "super" | "retry") > noident {node(p, text.to_sym)}
  def _special

    _save = self.pos
    while true # sequence
      _tmp = apply(:_p)
      p = @result
      unless _tmp
        self.pos = _save
        break
      end
      _text_start = self.pos

      _save1 = self.pos
      while true # choice
        _tmp = match_string("self")
        break if _tmp
        self.pos = _save1
        _tmp = match_string("nil")
        break if _tmp
        self.pos = _save1
        _tmp = match_string("super")
        break if _tmp
        self.pos = _save1
        _tmp = match_string("retry")
        break if _tmp
        self.pos = _save1
        break
      end # end choice

      if _tmp
        text = get_text(_text_start)
      end
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = apply(:_noident)
      unless _tmp
        self.pos = _save
        break
      end
      @result = begin; node(p, text.to_sym); end
      _tmp = true
      unless _tmp
        self.pos = _save
      end
      break
    end # end sequence

    set_failed_rule :_special unless _tmp
    return _tmp
  end

  # constant = (constant:c space+ const:o { c.args.push o; c } | p:p const:c {node(p, :const, c)})
  def _constant

    _save = self.pos
    while true # choice

      _save1 = self.pos
      while true # sequence
        _tmp = apply(:_constant)
        c = @result
        unless _tmp
          self.pos = _save1
          break
        end
        _save2 = self.pos
        _tmp = apply(:_space)
        if _tmp
          while true
            _tmp = apply(:_space)
            break unless _tmp
          end
          _tmp = true
        else
          self.pos = _save2
        end
        unless _tmp
          self.pos = _save1
          break
        end
        _tmp = apply(:_const)
        o = @result
        unless _tmp
          self.pos = _save1
          break
        end
        @result = begin;  c.args.push o; c ; end
        _tmp = true
        unless _tmp
          self.pos = _save1
        end
        break
      end # end sequence

      break if _tmp
      self.pos = _save

      _save3 = self.pos
      while true # sequence
        _tmp = apply(:_p)
        p = @result
        unless _tmp
          self.pos = _save3
          break
        end
        _tmp = apply(:_const)
        c = @result
        unless _tmp
          self.pos = _save3
          break
        end
        @result = begin; node(p, :const, c); end
        _tmp = true
        unless _tmp
          self.pos = _save3
        end
        break
      end # end sequence

      break if _tmp
      self.pos = _save
      break
    end # end choice

    set_failed_rule :_constant unless _tmp
    return _tmp
  end

  # identifier = p:p ident:i {node(p, :ident, i)}
  def _identifier

    _save = self.pos
    while true # sequence
      _tmp = apply(:_p)
      p = @result
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = apply(:_ident)
      i = @result
      unless _tmp
        self.pos = _save
        break
      end
      @result = begin; node(p, :ident, i); end
      _tmp = true
      unless _tmp
        self.pos = _save
      end
      break
    end # end sequence

    set_failed_rule :_identifier unless _tmp
    return _tmp
  end

  # literal = (float | fixnum | str | symbol | regexp)
  def _literal

    _save = self.pos
    while true # choice
      _tmp = apply(:_float)
      break if _tmp
      self.pos = _save
      _tmp = apply(:_fixnum)
      break if _tmp
      self.pos = _save
      _tmp = apply(:_str)
      break if _tmp
      self.pos = _save
      _tmp = apply(:_symbol)
      break if _tmp
      self.pos = _save
      _tmp = apply(:_regexp)
      break if _tmp
      self.pos = _save
      break
    end # end choice

    set_failed_rule :_literal unless _tmp
    return _tmp
  end

  # regexp = p:p quoted(:text, &"/"):b {node(p, :regexp, text_node(p, b))}
  def _regexp

    _save = self.pos
    while true # sequence
      _tmp = apply(:_p)
      p = @result
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = apply_with_args(:_quoted, :text, (@refargs[6] ||= Proc.new {
        _tmp = match_string("/")
        _tmp
      }))
      b = @result
      unless _tmp
        self.pos = _save
        break
      end
      @result = begin; node(p, :regexp, text_node(p, b)); end
      _tmp = true
      unless _tmp
        self.pos = _save
      end
      break
    end # end sequence

    set_failed_rule :_regexp unless _tmp
    return _tmp
  end

  # float = p:p sign:s dec:n "." dec:f {node(p, :float, (s+n+"."+f).to_f)}
  def _float

    _save = self.pos
    while true # sequence
      _tmp = apply(:_p)
      p = @result
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = apply(:_sign)
      s = @result
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = apply(:_dec)
      n = @result
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = match_string(".")
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = apply(:_dec)
      f = @result
      unless _tmp
        self.pos = _save
        break
      end
      @result = begin; node(p, :float, (s+n+"."+f).to_f); end
      _tmp = true
      unless _tmp
        self.pos = _save
      end
      break
    end # end sequence

    set_failed_rule :_float unless _tmp
    return _tmp
  end

  # fixnum = p:p (hexadec | binary | octal | decimal):n {node(p, :fixnum, n)}
  def _fixnum

    _save = self.pos
    while true # sequence
      _tmp = apply(:_p)
      p = @result
      unless _tmp
        self.pos = _save
        break
      end

      _save1 = self.pos
      while true # choice
        _tmp = apply(:_hexadec)
        break if _tmp
        self.pos = _save1
        _tmp = apply(:_binary)
        break if _tmp
        self.pos = _save1
        _tmp = apply(:_octal)
        break if _tmp
        self.pos = _save1
        _tmp = apply(:_decimal)
        break if _tmp
        self.pos = _save1
        break
      end # end choice

      n = @result
      unless _tmp
        self.pos = _save
        break
      end
      @result = begin; node(p, :fixnum, n); end
      _tmp = true
      unless _tmp
        self.pos = _save
      end
      break
    end # end sequence

    set_failed_rule :_fixnum unless _tmp
    return _tmp
  end

  # digits = < d+ ("_" d+)* > { text.gsub('_', '') }
  def _digits(d)

    _save = self.pos
    while true # sequence
      _text_start = self.pos

      _save1 = self.pos
      while true # sequence
        _save2 = self.pos
        _tmp = d.call()
        if _tmp
          while true
            _tmp = d.call()
            break unless _tmp
          end
          _tmp = true
        else
          self.pos = _save2
        end
        unless _tmp
          self.pos = _save1
          break
        end
        while true

          _save4 = self.pos
          while true # sequence
            _tmp = match_string("_")
            unless _tmp
              self.pos = _save4
              break
            end
            _save5 = self.pos
            _tmp = d.call()
            if _tmp
              while true
                _tmp = d.call()
                break unless _tmp
              end
              _tmp = true
            else
              self.pos = _save5
            end
            unless _tmp
              self.pos = _save4
            end
            break
          end # end sequence

          break unless _tmp
        end
        _tmp = true
        unless _tmp
          self.pos = _save1
        end
        break
      end # end sequence

      if _tmp
        text = get_text(_text_start)
      end
      unless _tmp
        self.pos = _save
        break
      end
      @result = begin;  text.gsub('_', '') ; end
      _tmp = true
      unless _tmp
        self.pos = _save
      end
      break
    end # end sequence

    set_failed_rule :_digits unless _tmp
    return _tmp
  end

  # sign = ("+" {"+"} | "-" { "-"} | {"+"})
  def _sign

    _save = self.pos
    while true # choice

      _save1 = self.pos
      while true # sequence
        _tmp = match_string("+")
        unless _tmp
          self.pos = _save1
          break
        end
        @result = begin; "+"; end
        _tmp = true
        unless _tmp
          self.pos = _save1
        end
        break
      end # end sequence

      break if _tmp
      self.pos = _save

      _save2 = self.pos
      while true # sequence
        _tmp = match_string("-")
        unless _tmp
          self.pos = _save2
          break
        end
        @result = begin;  "-"; end
        _tmp = true
        unless _tmp
          self.pos = _save2
        end
        break
      end # end sequence

      break if _tmp
      self.pos = _save
      @result = begin; "+"; end
      _tmp = true
      break if _tmp
      self.pos = _save
      break
    end # end choice

    set_failed_rule :_sign unless _tmp
    return _tmp
  end

  # dec = digits(&/[0-9]/):d {d}
  def _dec

    _save = self.pos
    while true # sequence
      _tmp = apply_with_args(:_digits, (@refargs[7] ||= Proc.new {
        _tmp = scan(/\A(?-mix:[0-9])/)
        _tmp
      }))
      d = @result
      unless _tmp
        self.pos = _save
        break
      end
      @result = begin; d; end
      _tmp = true
      unless _tmp
        self.pos = _save
      end
      break
    end # end sequence

    set_failed_rule :_dec unless _tmp
    return _tmp
  end

  # oct = "0" /[oO]/? digits(&/[0-7]/):d {d}
  def _oct

    _save = self.pos
    while true # sequence
      _tmp = match_string("0")
      unless _tmp
        self.pos = _save
        break
      end
      _save1 = self.pos
      _tmp = scan(/\A(?-mix:[oO])/)
      unless _tmp
        _tmp = true
        self.pos = _save1
      end
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = apply_with_args(:_digits, (@refargs[8] ||= Proc.new {
        _tmp = scan(/\A(?-mix:[0-7])/)
        _tmp
      }))
      d = @result
      unless _tmp
        self.pos = _save
        break
      end
      @result = begin; d; end
      _tmp = true
      unless _tmp
        self.pos = _save
      end
      break
    end # end sequence

    set_failed_rule :_oct unless _tmp
    return _tmp
  end

  # hex = "0" /[xX]/ digits(&/[0-9a-fA-F]/):d {d}
  def _hex

    _save = self.pos
    while true # sequence
      _tmp = match_string("0")
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = scan(/\A(?-mix:[xX])/)
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = apply_with_args(:_digits, (@refargs[9] ||= Proc.new {
        _tmp = scan(/\A(?-mix:[0-9a-fA-F])/)
        _tmp
      }))
      d = @result
      unless _tmp
        self.pos = _save
        break
      end
      @result = begin; d; end
      _tmp = true
      unless _tmp
        self.pos = _save
      end
      break
    end # end sequence

    set_failed_rule :_hex unless _tmp
    return _tmp
  end

  # bin = "0" /[bB]/ digits(&/[0-1]/):d {d}
  def _bin

    _save = self.pos
    while true # sequence
      _tmp = match_string("0")
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = scan(/\A(?-mix:[bB])/)
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = apply_with_args(:_digits, (@refargs[10] ||= Proc.new {
        _tmp = scan(/\A(?-mix:[0-1])/)
        _tmp
      }))
      d = @result
      unless _tmp
        self.pos = _save
        break
      end
      @result = begin; d; end
      _tmp = true
      unless _tmp
        self.pos = _save
      end
      break
    end # end sequence

    set_failed_rule :_bin unless _tmp
    return _tmp
  end

  # hexadec = sign:s hex:d {(s+d).to_i(16)}
  def _hexadec

    _save = self.pos
    while true # sequence
      _tmp = apply(:_sign)
      s = @result
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = apply(:_hex)
      d = @result
      unless _tmp
        self.pos = _save
        break
      end
      @result = begin; (s+d).to_i(16); end
      _tmp = true
      unless _tmp
        self.pos = _save
      end
      break
    end # end sequence

    set_failed_rule :_hexadec unless _tmp
    return _tmp
  end

  # binary = sign:s bin:d {(s+d).to_i(2)}
  def _binary

    _save = self.pos
    while true # sequence
      _tmp = apply(:_sign)
      s = @result
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = apply(:_bin)
      d = @result
      unless _tmp
        self.pos = _save
        break
      end
      @result = begin; (s+d).to_i(2); end
      _tmp = true
      unless _tmp
        self.pos = _save
      end
      break
    end # end sequence

    set_failed_rule :_binary unless _tmp
    return _tmp
  end

  # octal = sign:s oct:d {(s+d).to_i(8)}
  def _octal

    _save = self.pos
    while true # sequence
      _tmp = apply(:_sign)
      s = @result
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = apply(:_oct)
      d = @result
      unless _tmp
        self.pos = _save
        break
      end
      @result = begin; (s+d).to_i(8); end
      _tmp = true
      unless _tmp
        self.pos = _save
      end
      break
    end # end sequence

    set_failed_rule :_octal unless _tmp
    return _tmp
  end

  # decimal = sign:s dec:d {(s+d).to_i(10)}
  def _decimal

    _save = self.pos
    while true # sequence
      _tmp = apply(:_sign)
      s = @result
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = apply(:_dec)
      d = @result
      unless _tmp
        self.pos = _save
        break
      end
      @result = begin; (s+d).to_i(10); end
      _tmp = true
      unless _tmp
        self.pos = _save
      end
      break
    end # end sequence

    set_failed_rule :_decimal unless _tmp
    return _tmp
  end

  # symbol = p:p "'" (str | sym):i {node(p, :symbol, i)}
  def _symbol

    _save = self.pos
    while true # sequence
      _tmp = apply(:_p)
      p = @result
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = match_string("'")
      unless _tmp
        self.pos = _save
        break
      end

      _save1 = self.pos
      while true # choice
        _tmp = apply(:_str)
        break if _tmp
        self.pos = _save1
        _tmp = apply(:_sym)
        break if _tmp
        self.pos = _save1
        break
      end # end choice

      i = @result
      unless _tmp
        self.pos = _save
        break
      end
      @result = begin; node(p, :symbol, i); end
      _tmp = true
      unless _tmp
        self.pos = _save
      end
      break
    end # end sequence

    set_failed_rule :_symbol unless _tmp
    return _tmp
  end

  # sym = < (ident | oper | const | ":" | "[]" | "=" | "|")+ > {text}
  def _sym

    _save = self.pos
    while true # sequence
      _text_start = self.pos
      _save1 = self.pos

      _save2 = self.pos
      while true # choice
        _tmp = apply(:_ident)
        break if _tmp
        self.pos = _save2
        _tmp = apply(:_oper)
        break if _tmp
        self.pos = _save2
        _tmp = apply(:_const)
        break if _tmp
        self.pos = _save2
        _tmp = match_string(":")
        break if _tmp
        self.pos = _save2
        _tmp = match_string("[]")
        break if _tmp
        self.pos = _save2
        _tmp = match_string("=")
        break if _tmp
        self.pos = _save2
        _tmp = match_string("|")
        break if _tmp
        self.pos = _save2
        break
      end # end choice

      if _tmp
        while true

          _save3 = self.pos
          while true # choice
            _tmp = apply(:_ident)
            break if _tmp
            self.pos = _save3
            _tmp = apply(:_oper)
            break if _tmp
            self.pos = _save3
            _tmp = apply(:_const)
            break if _tmp
            self.pos = _save3
            _tmp = match_string(":")
            break if _tmp
            self.pos = _save3
            _tmp = match_string("[]")
            break if _tmp
            self.pos = _save3
            _tmp = match_string("=")
            break if _tmp
            self.pos = _save3
            _tmp = match_string("|")
            break if _tmp
            self.pos = _save3
            break
          end # end choice

          break unless _tmp
        end
        _tmp = true
      else
        self.pos = _save1
      end
      if _tmp
        text = get_text(_text_start)
      end
      unless _tmp
        self.pos = _save
        break
      end
      @result = begin; text; end
      _tmp = true
      unless _tmp
        self.pos = _save
      end
      break
    end # end sequence

    set_failed_rule :_sym unless _tmp
    return _tmp
  end

  # str = (mstr | sstr)
  def _str

    _save = self.pos
    while true # choice
      _tmp = apply(:_mstr)
      break if _tmp
      self.pos = _save
      _tmp = apply(:_sstr)
      break if _tmp
      self.pos = _save
      break
    end # end choice

    set_failed_rule :_str unless _tmp
    return _tmp
  end

  # sstr = p:p quoted(:text, &"\""):b {text_node(p, b)}
  def _sstr

    _save = self.pos
    while true # sequence
      _tmp = apply(:_p)
      p = @result
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = apply_with_args(:_quoted, :text, (@refargs[11] ||= Proc.new {
        _tmp = match_string("\"")
        _tmp
      }))
      b = @result
      unless _tmp
        self.pos = _save
        break
      end
      @result = begin; text_node(p, b); end
      _tmp = true
      unless _tmp
        self.pos = _save
      end
      break
    end # end sequence

    set_failed_rule :_sstr unless _tmp
    return _tmp
  end

  # quoted = q quoted_inner(t, q)*:b q {b}
  def _quoted(t,q)

    _save = self.pos
    while true # sequence
      _tmp = q.call()
      unless _tmp
        self.pos = _save
        break
      end
      _ary = []
      while true
        _tmp = apply_with_args(:_quoted_inner, t, q)
        _ary << @result if _tmp
        break unless _tmp
      end
      _tmp = true
      @result = _ary
      b = @result
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = q.call()
      unless _tmp
        self.pos = _save
        break
      end
      @result = begin; b; end
      _tmp = true
      unless _tmp
        self.pos = _save
      end
      break
    end # end sequence

    set_failed_rule :_quoted unless _tmp
    return _tmp
  end

  # quoted_inner = (p:p "#{" - body?:b - "}" {b} | p:p < ("\\" q | "\\#" | &(!(q | "#{")) .)+ > {node(p, t, text)})
  def _quoted_inner(t,q)

    _save = self.pos
    while true # choice

      _save1 = self.pos
      while true # sequence
        _tmp = apply(:_p)
        p = @result
        unless _tmp
          self.pos = _save1
          break
        end
        _tmp = match_string("\#{")
        unless _tmp
          self.pos = _save1
          break
        end
        _tmp = apply(:__hyphen_)
        unless _tmp
          self.pos = _save1
          break
        end
        _save2 = self.pos
        _tmp = apply(:_body)
        @result = nil unless _tmp
        unless _tmp
          _tmp = true
          self.pos = _save2
        end
        b = @result
        unless _tmp
          self.pos = _save1
          break
        end
        _tmp = apply(:__hyphen_)
        unless _tmp
          self.pos = _save1
          break
        end
        _tmp = match_string("}")
        unless _tmp
          self.pos = _save1
          break
        end
        @result = begin; b; end
        _tmp = true
        unless _tmp
          self.pos = _save1
        end
        break
      end # end sequence

      break if _tmp
      self.pos = _save

      _save3 = self.pos
      while true # sequence
        _tmp = apply(:_p)
        p = @result
        unless _tmp
          self.pos = _save3
          break
        end
        _text_start = self.pos
        _save4 = self.pos

        _save5 = self.pos
        while true # choice

          _save6 = self.pos
          while true # sequence
            _tmp = match_string("\\")
            unless _tmp
              self.pos = _save6
              break
            end
            _tmp = q.call()
            unless _tmp
              self.pos = _save6
            end
            break
          end # end sequence

          break if _tmp
          self.pos = _save5
          _tmp = match_string("\\#")
          break if _tmp
          self.pos = _save5

          _save7 = self.pos
          while true # sequence
            _save8 = self.pos
            _save9 = self.pos

            _save10 = self.pos
            while true # choice
              _tmp = q.call()
              break if _tmp
              self.pos = _save10
              _tmp = match_string("\#{")
              break if _tmp
              self.pos = _save10
              break
            end # end choice

            _tmp = _tmp ? nil : true
            self.pos = _save9
            self.pos = _save8
            unless _tmp
              self.pos = _save7
              break
            end
            _tmp = get_byte
            unless _tmp
              self.pos = _save7
            end
            break
          end # end sequence

          break if _tmp
          self.pos = _save5
          break
        end # end choice

        if _tmp
          while true

            _save11 = self.pos
            while true # choice

              _save12 = self.pos
              while true # sequence
                _tmp = match_string("\\")
                unless _tmp
                  self.pos = _save12
                  break
                end
                _tmp = q.call()
                unless _tmp
                  self.pos = _save12
                end
                break
              end # end sequence

              break if _tmp
              self.pos = _save11
              _tmp = match_string("\\#")
              break if _tmp
              self.pos = _save11

              _save13 = self.pos
              while true # sequence
                _save14 = self.pos
                _save15 = self.pos

                _save16 = self.pos
                while true # choice
                  _tmp = q.call()
                  break if _tmp
                  self.pos = _save16
                  _tmp = match_string("\#{")
                  break if _tmp
                  self.pos = _save16
                  break
                end # end choice

                _tmp = _tmp ? nil : true
                self.pos = _save15
                self.pos = _save14
                unless _tmp
                  self.pos = _save13
                  break
                end
                _tmp = get_byte
                unless _tmp
                  self.pos = _save13
                end
                break
              end # end sequence

              break if _tmp
              self.pos = _save11
              break
            end # end choice

            break unless _tmp
          end
          _tmp = true
        else
          self.pos = _save4
        end
        if _tmp
          text = get_text(_text_start)
        end
        unless _tmp
          self.pos = _save3
          break
        end
        @result = begin; node(p, t, text); end
        _tmp = true
        unless _tmp
          self.pos = _save3
        end
        break
      end # end sequence

      break if _tmp
      self.pos = _save
      break
    end # end choice

    set_failed_rule :_quoted_inner unless _tmp
    return _tmp
  end

  # mstr = p:p "\"\"\"" mstr_inner*:b "\"\"\"" {text_node(p, b)}
  def _mstr

    _save = self.pos
    while true # sequence
      _tmp = apply(:_p)
      p = @result
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = match_string("\"\"\"")
      unless _tmp
        self.pos = _save
        break
      end
      _ary = []
      while true
        _tmp = apply(:_mstr_inner)
        _ary << @result if _tmp
        break unless _tmp
      end
      _tmp = true
      @result = _ary
      b = @result
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = match_string("\"\"\"")
      unless _tmp
        self.pos = _save
        break
      end
      @result = begin; text_node(p, b); end
      _tmp = true
      unless _tmp
        self.pos = _save
      end
      break
    end # end sequence

    set_failed_rule :_mstr unless _tmp
    return _tmp
  end

  # mstr_inner = (p:p "#{" - body?:b - "}" {b} | p:p < ("\\\"\"\"" | !(&("\"\"\"" | "#{")) . | . &"\"\"\"")+ > {node(p, :text, text)})
  def _mstr_inner

    _save = self.pos
    while true # choice

      _save1 = self.pos
      while true # sequence
        _tmp = apply(:_p)
        p = @result
        unless _tmp
          self.pos = _save1
          break
        end
        _tmp = match_string("\#{")
        unless _tmp
          self.pos = _save1
          break
        end
        _tmp = apply(:__hyphen_)
        unless _tmp
          self.pos = _save1
          break
        end
        _save2 = self.pos
        _tmp = apply(:_body)
        @result = nil unless _tmp
        unless _tmp
          _tmp = true
          self.pos = _save2
        end
        b = @result
        unless _tmp
          self.pos = _save1
          break
        end
        _tmp = apply(:__hyphen_)
        unless _tmp
          self.pos = _save1
          break
        end
        _tmp = match_string("}")
        unless _tmp
          self.pos = _save1
          break
        end
        @result = begin; b; end
        _tmp = true
        unless _tmp
          self.pos = _save1
        end
        break
      end # end sequence

      break if _tmp
      self.pos = _save

      _save3 = self.pos
      while true # sequence
        _tmp = apply(:_p)
        p = @result
        unless _tmp
          self.pos = _save3
          break
        end
        _text_start = self.pos
        _save4 = self.pos

        _save5 = self.pos
        while true # choice
          _tmp = match_string("\\\"\"\"")
          break if _tmp
          self.pos = _save5

          _save6 = self.pos
          while true # sequence
            _save7 = self.pos
            _save8 = self.pos

            _save9 = self.pos
            while true # choice
              _tmp = match_string("\"\"\"")
              break if _tmp
              self.pos = _save9
              _tmp = match_string("\#{")
              break if _tmp
              self.pos = _save9
              break
            end # end choice

            self.pos = _save8
            _tmp = _tmp ? nil : true
            self.pos = _save7
            unless _tmp
              self.pos = _save6
              break
            end
            _tmp = get_byte
            unless _tmp
              self.pos = _save6
            end
            break
          end # end sequence

          break if _tmp
          self.pos = _save5

          _save10 = self.pos
          while true # sequence
            _tmp = get_byte
            unless _tmp
              self.pos = _save10
              break
            end
            _save11 = self.pos
            _tmp = match_string("\"\"\"")
            self.pos = _save11
            unless _tmp
              self.pos = _save10
            end
            break
          end # end sequence

          break if _tmp
          self.pos = _save5
          break
        end # end choice

        if _tmp
          while true

            _save12 = self.pos
            while true # choice
              _tmp = match_string("\\\"\"\"")
              break if _tmp
              self.pos = _save12

              _save13 = self.pos
              while true # sequence
                _save14 = self.pos
                _save15 = self.pos

                _save16 = self.pos
                while true # choice
                  _tmp = match_string("\"\"\"")
                  break if _tmp
                  self.pos = _save16
                  _tmp = match_string("\#{")
                  break if _tmp
                  self.pos = _save16
                  break
                end # end choice

                self.pos = _save15
                _tmp = _tmp ? nil : true
                self.pos = _save14
                unless _tmp
                  self.pos = _save13
                  break
                end
                _tmp = get_byte
                unless _tmp
                  self.pos = _save13
                end
                break
              end # end sequence

              break if _tmp
              self.pos = _save12

              _save17 = self.pos
              while true # sequence
                _tmp = get_byte
                unless _tmp
                  self.pos = _save17
                  break
                end
                _save18 = self.pos
                _tmp = match_string("\"\"\"")
                self.pos = _save18
                unless _tmp
                  self.pos = _save17
                end
                break
              end # end sequence

              break if _tmp
              self.pos = _save12
              break
            end # end choice

            break unless _tmp
          end
          _tmp = true
        else
          self.pos = _save4
        end
        if _tmp
          text = get_text(_text_start)
        end
        unless _tmp
          self.pos = _save3
          break
        end
        @result = begin; node(p, :text, text); end
        _tmp = true
        unless _tmp
          self.pos = _save3
        end
        break
      end # end sequence

      break if _tmp
      self.pos = _save
      break
    end # end choice

    set_failed_rule :_mstr_inner unless _tmp
    return _tmp
  end

  Rules = {}
  Rules[:_root] = rule_info("root", "- body:b - !. {b}")
  Rules[:_space] = rule_info("space", "(\" \" | \"\\t\" | \"\\\\\" nl)")
  Rules[:_nl] = rule_info("nl", "(\"\\n\" | \"\\n\" | \";\")")
  Rules[:_comment] = rule_info("comment", "\"\#\" /.*?$/")
  Rules[:__hyphen_] = rule_info("-", "(comment | space | nl)*")
  Rules[:_p] = rule_info("p", "&. {position}")
  Rules[:_body] = rule_info("body", "(body:b - chain:c { b.args.push c; b } | chain:c {node(c.pos, :body, c)})")
  Rules[:_chain] = rule_info("chain", "(chain:c space* \".\" !(&\".\") - (ruby | message):m { c.args.push m; c } | chain:c space* \".\" !(&\".\") {node(c.pos, :chain, c)} | chain:c space* access:m { c.args.push m; c } | chain:c space+ (ruby | message):m { c.args.push m; c } | range:r {node(r.pos, :chain, r)} | p:p value:v {node(p, :chain, v)})")
  Rules[:_args] = rule_info("args", "(args:a space* \",\" - body:c { a + [c] } | body:c {[c]})")
  Rules[:_ruby_name] = rule_info("ruby_name", "< (ident | const | oper | \"=\")+ > {text}")
  Rules[:_ruby] = rule_info("ruby", "(p:p ruby_name:n \"(\" - args?:a - \")\" space+ block:b {node(p, :ruby, n, b, *Array(a))} | p:p ruby_name:n \"(\" - args?:a - \")\" {node(p, :ruby, n, nil, *Array(a))})")
  Rules[:_access] = rule_info("access", "(p:p \"[\" - chain:a - \"]:\" space+ - value:b {node(p, :opmsg, \"[]\",a,b)} | p:p \"[\" - chain:a - \"]\" {node(p, :opmsg, \"[]\", a)})")
  Rules[:_message] = rule_info("message", "(p:p oper:o (space* \".\" !(&\".\"))? - value:v {node(p, :opmsg, o, v)} | collon:c {c} | p:p ident:i {node(p, :message, i)})")
  Rules[:_collon] = rule_info("collon", "(collon:c space+ ident:i \":\" space+ - value:v {c.args.push i, v; c} | p:p ident:i \":\" space+ - value:v {node(p, :message, i, v)})")
  Rules[:_block] = rule_info("block", "(p:p block_args:a - curly:b {node(p, :block, a, b)} | curly:b {node(p, :block, [], b)})")
  Rules[:_block_args] = rule_info("block_args", "\"|\" space* (tuple_items(&identifier) | block_params):a space* \"|\" {a}")
  Rules[:_curly] = rule_info("curly", "p:p \"{\" - body?:b - \"}\" {b || body_nil}")
  Rules[:_block_params] = rule_info("block_params", "(block_params:b space+ identifier:i {b + [i]} | identifier:i {[i]})")
  Rules[:_return_expr] = rule_info("return_expr", "p:p \"return\" noident (space+ chain:c)? {node(p, :return, c)}")
  Rules[:_return_local] = rule_info("return_local", "p:p \"return_local\" noident (space+ chain:c)? {node(p, :return_local, c)}")
  Rules[:_value] = rule_info("value", "(return_expr | return_local | assignment | expr)")
  Rules[:_name] = rule_info("name", "(identifier | constant):n !(&(space* \":\")) {n}")
  Rules[:_eq] = rule_info("eq", "\"=\" (space | nl | comment)")
  Rules[:_assignment] = rule_info("assignment", "(p:p tuple_items(&name):a space+ eq - (tuple_items(&chain) | chain:c {[c]}):b {node(p, :massign, a, b)} | p:p name:a space+ eq - chain:b {node(p, :assign, a, b)})")
  Rules[:_tuple] = rule_info("tuple", "p:p \"(\" - tuple_items(&body):v - \")\" {node(p, :tuple, *v)}")
  Rules[:_array] = rule_info("array", "p:p \"[\" - maybe_items(&body):v - \"]\" {node(p, :array, *v)}")
  Rules[:_hash] = rule_info("hash", "p:p \"<[\" - maybe_items(&pair):v - \"]>\" {node(p, :hash, *v)}")
  Rules[:_pair] = rule_info("pair", "chain:a space+ \"=>\" space+ chain:b {[a, b]}")
  Rules[:_range] = rule_info("range", "p:p value:a space+ \"..\" space+ value:b {node(p, :range, a, b)}")
  Rules[:_expr] = rule_info("expr", "(tuple | array | hash | \"(\" - body:v - \")\" {v} | \"$\" space+ chain:c {c} | classdef | methodef | match | trycatch | literal | block | ruby | special | name | message)")
  Rules[:_maybe_items] = rule_info("maybe_items", "t?:a (space* \",\" - t:o {o})*:n {[a,n].flatten.compact}")
  Rules[:_tuple_items] = rule_info("tuple_items", "t:a (space* \",\" - t:o {o})+:n {[a,n].flatten}")
  Rules[:_trycatch] = rule_info("trycatch", "(p:p \"try\" space+ curly:t space+ ((catches | {[]}):c space+)? finally:f {node(p, :try, t, c, f)} | p:p \"try\" space+ curly:t space+ catches:c {node(p, :try, t, c)})")
  Rules[:_finally] = rule_info("finally", "p:p \"finally\" space+ curly:f {node(p, :finally, f)}")
  Rules[:_catche] = rule_info("catche", "(p:p \"catch\" space+ curly:b {node(p, :catch, b, node(p, :const, \"Object\"))} | p:p \"catch\" space+ value:v space+ \"=>\" space+ identifier:i space+ curly:b {node(p, :catch, b, v, i)} | p:p \"catch\" space+ value:v space+ curly:b {node(p, :catch, b, v)})")
  Rules[:_catches] = rule_info("catches", "(catches:s space+ catche:c {s+[c]} | catche:c {[c]})")
  Rules[:_match] = rule_info("match", "p:p \"match\" space+ chain:v space+ \"{\" - match_cases:c - \"}\" {node(p, :match, v, *c)}")
  Rules[:_match_cases] = rule_info("match_cases", "(match_cases:s - match_case:c {s + [c]} | match_case:c {[c]})")
  Rules[:_match_case] = rule_info("match_case", "(p:p \"case\" space+ value:v space+ \"->\" space+ block_args:a - body:b {node(p, :case, v, a, b)} | p:p \"case\" space+ value:v space+ \"->\" - body:b {node(p, :case, v, [], b)})")
  Rules[:_classdef] = rule_info("classdef", "p:p \"class\" space+ constant:c space+ (\":\" space+ constant:s space+)? curly:b {node(p, :class, c, s, b)}")
  Rules[:_opdef] = rule_info("opdef", "(\"[\" space* ident:i space* \"]:\" space+ ident:k space+ curly:b {[\"[]\", i, k, b]} | \"[\" space* ident:i space* \"]\" space+ curly:b {[\"[]\", i,b]} | oper:o space+ ident:i space+ curly:b {[o, i, b]})")
  Rules[:_methodef] = rule_info("methodef", "(methdef | operdef | smethdef | soperdef)")
  Rules[:_operdef] = rule_info("operdef", "p:p \"def\" space+ opdef:a {node(p, :oper, *a)}")
  Rules[:_soperdef] = rule_info("soperdef", "p:p \"def\" space+ value:v space+ opdef:a {node(p, :soper, v, *a)}")
  Rules[:_methdef] = rule_info("methdef", "p:p \"def\" space+ params:m (space+ curly | space* &(nl | comment) {body_nil}):b {node(p, :method, m, b)}")
  Rules[:_smethdef] = rule_info("smethdef", "p:p \"def\" space+ value:v space+ params:m (space+ curly | space* &(nl | comment) {body_nil}):b {node(p, :smethod, v, m, b)}")
  Rules[:_params] = rule_info("params", "(selectors:s {s} | p:p ident:i {node(p, :param, [i])})")
  Rules[:_param] = rule_info("param", "(p:p ident:i space+ \"(\" body:b \")\" {[i, b]} | p:p ident:i {[i]})")
  Rules[:_selectors] = rule_info("selectors", "(selectors:s space+ ident:i \":\" space+ param:a { s.args.push [i]+a; s } | p:p ident:i \":\" space+ param:a {node(p, :param, [i]+a)})")
  Rules[:_const] = rule_info("const", "< /[A-Z][a-zA-Z0-9_]*/ > {text}")
  Rules[:_ident] = rule_info("ident", "< \"@\"? \"@\"? /[a-z_][a-zA-Z0-9_\\?\\!]*/ > &{ident?(text)} {text}")
  Rules[:_oper] = rule_info("oper", "< (/[?!=*\\/^><%&~+-]+/ | \"||\" /[?!=*\\/^><%&~+_-]*/) > &{oper?(text)} {text}")
  Rules[:_noident] = rule_info("noident", "!(&/[a-zA-Z0-9_\\?\\!]/)")
  Rules[:_special] = rule_info("special", "p:p < (\"self\" | \"nil\" | \"super\" | \"retry\") > noident {node(p, text.to_sym)}")
  Rules[:_constant] = rule_info("constant", "(constant:c space+ const:o { c.args.push o; c } | p:p const:c {node(p, :const, c)})")
  Rules[:_identifier] = rule_info("identifier", "p:p ident:i {node(p, :ident, i)}")
  Rules[:_literal] = rule_info("literal", "(float | fixnum | str | symbol | regexp)")
  Rules[:_regexp] = rule_info("regexp", "p:p quoted(:text, &\"/\"):b {node(p, :regexp, text_node(p, b))}")
  Rules[:_float] = rule_info("float", "p:p sign:s dec:n \".\" dec:f {node(p, :float, (s+n+\".\"+f).to_f)}")
  Rules[:_fixnum] = rule_info("fixnum", "p:p (hexadec | binary | octal | decimal):n {node(p, :fixnum, n)}")
  Rules[:_digits] = rule_info("digits", "< d+ (\"_\" d+)* > { text.gsub('_', '') }")
  Rules[:_sign] = rule_info("sign", "(\"+\" {\"+\"} | \"-\" { \"-\"} | {\"+\"})")
  Rules[:_dec] = rule_info("dec", "digits(&/[0-9]/):d {d}")
  Rules[:_oct] = rule_info("oct", "\"0\" /[oO]/? digits(&/[0-7]/):d {d}")
  Rules[:_hex] = rule_info("hex", "\"0\" /[xX]/ digits(&/[0-9a-fA-F]/):d {d}")
  Rules[:_bin] = rule_info("bin", "\"0\" /[bB]/ digits(&/[0-1]/):d {d}")
  Rules[:_hexadec] = rule_info("hexadec", "sign:s hex:d {(s+d).to_i(16)}")
  Rules[:_binary] = rule_info("binary", "sign:s bin:d {(s+d).to_i(2)}")
  Rules[:_octal] = rule_info("octal", "sign:s oct:d {(s+d).to_i(8)}")
  Rules[:_decimal] = rule_info("decimal", "sign:s dec:d {(s+d).to_i(10)}")
  Rules[:_symbol] = rule_info("symbol", "p:p \"'\" (str | sym):i {node(p, :symbol, i)}")
  Rules[:_sym] = rule_info("sym", "< (ident | oper | const | \":\" | \"[]\" | \"=\" | \"|\")+ > {text}")
  Rules[:_str] = rule_info("str", "(mstr | sstr)")
  Rules[:_sstr] = rule_info("sstr", "p:p quoted(:text, &\"\\\"\"):b {text_node(p, b)}")
  Rules[:_quoted] = rule_info("quoted", "q quoted_inner(t, q)*:b q {b}")
  Rules[:_quoted_inner] = rule_info("quoted_inner", "(p:p \"\#{\" - body?:b - \"}\" {b} | p:p < (\"\\\\\" q | \"\\\\\#\" | &(!(q | \"\#{\")) .)+ > {node(p, t, text)})")
  Rules[:_mstr] = rule_info("mstr", "p:p \"\\\"\\\"\\\"\" mstr_inner*:b \"\\\"\\\"\\\"\" {text_node(p, b)}")
  Rules[:_mstr_inner] = rule_info("mstr_inner", "(p:p \"\#{\" - body?:b - \"}\" {b} | p:p < (\"\\\\\\\"\\\"\\\"\" | !(&(\"\\\"\\\"\\\"\" | \"\#{\")) . | . &\"\\\"\\\"\\\"\")+ > {node(p, :text, text)})")
end
