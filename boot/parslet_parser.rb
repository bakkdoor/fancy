require 'parslet'

class FancyParser < Parslet::Parser
  root(:program)

  rule(:program){
    expression_list
  }

  rule(:delim){
    nls | tSEMI | delim >> delim
  }

  rule(:nls){
    tNL | nls >> tNL
  }

  rule(:space){
    str(' ') | nls
  }

  rule(:code){
    statement | exp
  }

  rule(:expression_list){
    code | (expression_list >> code) | (delim >> expression_list) | (expression_list >> delim)
  }

  rule(:expression_block){
    (tLCURLY >> space >> expression_list >> space >> tRCURLY) | (tLCURLY >> space >> tRCURLY)
  }

  rule(:statement){
    assignment | return_local_statement | return_statement
  }

  rule(:exp){
    method_def | class_def |
    try_catch_block |
    match_expr |
    message_send |
    operator_send |
    ruby_send | ruby_oper_send |
    literal_value | any_identifier | tSUPER | tRETRY |
    (tLPAREN >> space >> exp >> space >> tRPAREN) |
    (exp >> tDOT >> space)
  }

  rule(:tEQUALS){
    str('=')
  }

  rule(:assignment){
    (any_identifier >> tEQUALS >> space >> exp) | multiple_assignment
  }

  rule(:multiple_assignment){
    identifier_list >> tEQUALS >> exp_comma_list
  }

  rule(:tSPECIAL){ match('[+?!=*/^><%&~-]') }
  rule(:tSPECIAL_UNDER){ tSPECIAL | str('_') }

  rule(:operator){
    (special.repeat(1) | str('||') >> tSPECIAL_UNDER).as(:op)
  }

  rule(:tCAPITAL){
    match('[A-Z]')
  }

  rule(:tLETTER){
    match('[A-Za-z]')
  }

  rule(:tCONSTANT){
    tCAPITAL >> (tLETTER | tDIGIT | tSPECIAL_UNDER).repeat
  }

  rule(:constant){
    (
      (str('::') >> tCONSTANT).repeat(1) |
      (str('::') >> tCONSTANT) |
      (tCONSTANT >> (str('::') >> tCONSTANT).repeat) |
      (tCONSTANT)
    ).as(:const)
  }

  rule(:tIDENTIFIER){
    ( str('@').repeat(0,2) >> (
        lower | match('[_&*]')
      ) >> (
        letter | digit | special_under
      ).repeat
    )
  }

  rule(:identifier){
    tIDENTIFIER | tMATCH | tCLASS
  }

  rule(:any_identifier){
    const_identifier | identifier
  }

  rule(:identifier_list){
    any_identifier | (identifier_list >> tCOMMA >> any_identifier)
  }

  rule(:return_local_statement){
    (tRETURN_LOCAL >> exp) | tRETURN_LOCAL
  }

  rule(:return_statement){
    (tRETURN exp) | tRETURN
  }

  rule(:class_def){
    class_no_super | class_super
  }

  rule(:const_identifier){
    constant | (const_identifier >> constant)
  }

  rule(:def_method){
    (tDEF >> tPRIVATE) | (tDEF tPROTECTED) | tDEF
  }

  rule(:class_no_super){
    tCLASS >> const_identifier >> expression_block
  }

  rule(:class_super){
    tCLASS >> const_identifier >> tCOLON >> const_identifier >> expression_block
  }

  rule(:method_def){
    method_w_args | method_no_args | class_method_w_args | class_method_no_args | operator_def | class_operator_def
  }

  rule(:method_arg){
    identifier >> tCOLON >> identifier
  }

  rule(:method_args){
    method_arg | (method_args >> method_arg) >> (method_args method_args_default)
  }

  rule(:method_arg_default){
    identifier >> tCOLON >> identifier >> tLPAREN >> space >> exp >> space >> tRPAREN
  }

  rule(:method_args_default){
    method_arg_default | (method_args_default >> space >> method_arg_default)
  }

  rule(:method_w_args){
    def_method >> method_args >> expression_block
  }

  rule(:method_no_args){
    def_method >> identifier >> expression_block
  }

  rule(:class_method_w_args){
    def_method >> any_identifier >> method_args >> expression_block
  }

  rule(:class_method_no_args){
    def_method >> any_identifier >> identifier >> expression_block
  }

  rule(:operator_def){
    (def_method >> operator >> identifier >> expression_block) |
    (def_method >> tBRACKET >> tRBRACKET >> identifier >> expression_block)
  }

  rule(:class_operator_def){
    (def_method >> any_identifier >> operator >> identifier >> expression_block) |
    (def_method >> any_identifier >> tBRACKET >> tRBRACKET >> identifier >> expression_block)
  }

  rule(:message_send){
    (exp >> identifier) | (exp >> send_args) | send_args
  }

  rule(:tRUBY_SEND_OPEN){
    identifier >> tLPAREN
  }

  rule(:ruby_send_open){
    tRUBY_SEND_OPEN
  }

  rule(:tRUBY_OPER_OPEN){
    operator >> lparen
  }

  rule(:ruby_oper_open){
    tRUBY_OPER_OPEN
  }

  rule(:ruby_send){
    (exp >> ruby_send_open >> ruby_args) |
    (ruby_send_open ruby_args)
  }

  rule(:ruby_args){
    (tRPAREN >> block_literal) |
    (exp_comma_list >> tRPAREN >> block_literal) |
    tRPAREN |
    (exp_comma_list >> tRPAREN)
  }

  rule(:operator_send){
    (exp >> operator >> arg_exp) |
    (exp >> operator >> tDOT >> space >> arg_exp) |
    (exp >> tLBRACKET >> exp >> tRBRACKET)
  }

  rule(:ruby_oper_send){
    exp >> ruby_oper_open >> ruby_args
  }

  rule(:send_args){
    (identifier >> tCOLON >> arg_exp) |
    (identifier >> tCOLON >> space >> arg_exp) |
    (send_args >> identifier >> tCOLON >> arg_exp) |
    (send_args >> identifier >> tCOLON >> space >> arg_exp)
  }

  rule(:arg_exp){
    any_identifier | (tLPAREN >> exp >> tRPAREN) | literal_value | (tDOLLAR >> exp)
  }

  rule(:try_catch_block){
    (tTRY >> expression_block >> catch_blocks >> finally_block) |
    (tTRY >> expression_block >> required_catch_blocks)
  }

  rule(:catch_block){
    (tCATCH >> expression_block) |
    (tCATCH >> exp >> expression_block) |
    (tCATCH >> exp >> tARROW >> identifier >> expression_block)
  }

  rule(:required_catch_blocks){
    catch_block | (required_catch_blocks >> catch_block)
  }

  rule(:catch_blocks){
    catch_block | (catch_blocks catch_block) # | empty??? FIXME
  }

  rule(:finally_lbock){
    tFINALLY >> expression_block
  }

  rule(:tDIGIT){
    match('[0-9]')
  }

  rule(:tDIGIT_UNDERSCORED){
    (tDIGIT >> ((str('_') >> tDIGIT) | tDIGIT).repeat) |
    tDIGIT.repeat(1)
  }

  rule(:tINTEGER_LITERAL){
    match('[+-]').maybe >> tDIGIT_UNDERSCORED
  }

  rule(:integer_literal){
    tINTEGER_LITERAL.as(:int)
  }

  rule(:tDOUBLE_LITERAL){
    match('[+-]').maybe >>
    tDIGIT_UNDERSCORED >>
    str('.') >>
    tDIGIT_UNDERSCORED
  }

  rule(:double_literal){
    tDOUBLE_LITERAL.as(:dbl)
  }

  rule(:tSTRING_LITERAL){
    str('"') >> ( (str('\\') >> any) | (str('"').absnt? >> any)).repeat >> str('"')
  }

  rule(:string_literal){
    tSTRING_LITERAL.as(:str)
  }

  rule(:symbol_literal){
    tSYMBOL_LITERAL
  }

  rule(:regex_literal){
    tREGEX_LITERAL
  }

  rule(:tHEX_DIGIT){
    match('[0-9a-fA-F]')
  }

  rule(:tHEX_LITERAL){
    ((str('0x') | str('0X')) >> (
      (tHEX_DIGIT >> ((str('_') >> tHEX_DIGIT) | tHEX_DIGIT).repeat) |
      tHEX_DIGIT.repeat(1)))
  }

  rule(:hex_literal){
    tHEX_LITERAL.as(:hex)
  }

  rule(:tOCT_DIGIT){
    match('[0-7]')
  }

  rule(:tOCT_LITERAL){
    ((str('0o') | str('0O')) >> (
      (tOCT_DIGIT >> ((str('_') >> tOCT_DIGIT) | tOCT_DIGIT).repeat) |
      tOCT_DIGIT.repeat(1)))
  }

  rule(:oct_literal){
    tOCT_LITERAL.as(:oct)
  }

  rule(:tBIN_DIGIT){
    match('[01]')
  }

  rule(:tBIN_LITERAL){
    ((str('0b') | str('0B')) >> (
      (tBIN_DIGIT >> ((str('_') >> tBIN_DIGIT) | tBIN_DIGIT).repeat) |
      tBIN_DIGIT.repeat(1)))
  }

  rule(:bin_literal){
    tBIN_LITERAL.as(:bin)
  }

  rule(:literal_value){
    integer_literal | hex_literal | oct_literal | bin_literal | double_literal |
    string_literal | symbol_literal | hash_literal | array_literal |
    regex_literal | block_literal | tuple_literal | range_literal
  }

  rule(:array_literal){
    empty_array | (tLBRACKET >> space >> exp_comma_list >> space >> tRBRACKET)
  }

  rule(:exp_comma_list){
    exp | (exp_comma_list >> tCOMMA >> space >> exp)
  }

  rule(:empty_array){
    tLBRACKET >> space >> tRBRACKET
  }

  rule(:hash_literal){
    (tLHASH >> space >> key_value_list >> space >> tRHASH) | (tLHASH >> space >> tRHASH)
  }

  rule(:block_literal){
    expression_block | (tSTAB >> block_args >> tSTAB >> space >> expression_block)
  }

  rule(:tuple_literal){
    tLPAREN >> exp_comma_list >> tRPAREN
  }

  rule(:range_literal){
    tLPAREN >> exp >> tDOT >> tDOT >> exp >> tRPAREN
  }

  rule(:block_args){
    block_args_with_comma | block_args_without_comma
  }

  rule(:block_args_without_comma){
    identifier | (block_args_without_comma >> identifier)
  }

  rule(:block_args_with_comma){
    identifier | (block_args_with_comma >> tCOMMA >> identifier)
  }

  rule(:key_value_list){
    (exp >> space >> tARROW >> space >> exp) |
    (key_value_list >> tCOMMA >> space >> exp >> space >> tARROW >> space >> exp)
  }

  rule(:match_exp){
    tMATCH >> exp >> tLCURLY >> space >> match_body >> space >> tRCURLY
  }

  rule(:match_body){
    match_clause | (match_body >> match_clause)
  }

  rule(:match_clause){
    (tCASE >> exp >> tTHIN_ARROW >> expression_list) |
    (tCASE >> exp >> tTHIN_ARROW >> tSTAB >> block_args >> tSTAB >> expression_list)
  }
end

require 'bacon'
Bacon.summary_on_exit

describe FancyParser do
  def parse(str, node = :root)
    transform = Parslet::Transform.new do
      rule(:int => simple(:x)){ [:int, Integer(x)] }
      rule(:dbl => simple(:x)){ [:dbl, Float(x)] }
      rule(:hex => simple(:x)){ [:int, Integer(x)] }
      rule(:bin => simple(:x)){ [:int, Integer(x)] }
      rule(:oct => simple(:x)){ [:int, Integer(x)] }
      rule(:const => simple(:x)){ [:const, x] }
      rule(:symbol => simple(:x)){ [:sym, x.to_sym] }
      rule(:id => simple(:x)){ [:id, x] }
      rule(:class => sequence(:x)){ [:class, x[1]] }
      rule(:def => sequence(:x)){ [:def, x[1]] }
      rule(:op => simple(:x)){ [:op, x] }
      rule(:str => simple(:x)){ [:str, x.parent.slice(1, x.size - 2)] }
      rule(:mstr => simple(:x)){ [:mstr, x] }
      rule(:mstr => sequence(:x)){ [:mstr, x.join] }
    end

    parser = FancyParser.new
    tree = parser.send(node).parse(str)
    transform.apply(tree)
  rescue Parslet::ParseFailed => error
    puts
    puts error, parser.send(node).error_tree
    raise(error)
  end

  it 'parses integer literal' do
    parse('1', :integer_literal).should == [:int, 1]
    parse('12', :integer_literal).should == [:int, 12]
    parse('123', :integer_literal).should == [:int, 123]
    parse('123_456', :integer_literal).should == [:int, 123456]
    parse('+123_456', :integer_literal).should == [:int, 123456]
    parse('-123_456', :integer_literal).should == [:int, -123456]
  end

  it 'parses float literal' do
    parse('1.2', :double_literal).should == [:dbl, 1.2]
    parse('12.3', :double_literal).should == [:dbl, 12.3]
    parse('12.34', :double_literal).should == [:dbl, 12.34]
    parse('123.456', :double_literal).should == [:dbl, 123.456]
    parse('123_456.789_0', :double_literal).should == [:dbl, 123456.789_0]
    parse('+123.456', :double_literal).should == [:dbl, 123.456]
    parse('-123.456', :double_literal).should == [:dbl, -123.456]
  end

  it 'parses hexadecimal literal' do
    parse('0xdeadbeef', :hex_literal).should == [:int, 0xdeadbeef]
    parse('0Xdead_beef', :hex_literal).should == [:int, 0Xdead_beef]
  end

  it 'parses octal literal' do
    parse('0o777', :oct_literal).should == [:int, 0777]
    parse('0O5_2', :oct_literal).should == [:int, 42]
  end

  it 'parses binary literal' do
    parse('0b101010', :bin_literal).should == [:int, 42]
    parse('0B101_010', :bin_literal).should == [:int, 42]
  end

  it 'parses simple string literal' do
    parse(%(""), :string_literal).should == [:str, ""]
    parse(%("foo"), :string_literal).should == [:str, "foo"]
    parse(%(" \\" "), :string_literal).should == [:str, ' \" ']
  end

  it 'parses 1 + 2' do
    parse(%(1 + 2\n)).should == [[:int, 1], [:op, "+"], [:int, 2]]
  end
end
