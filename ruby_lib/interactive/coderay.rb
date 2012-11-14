# This is basically a big hacked version of CodeRay::Scanners::Ruby,
# since the language semantics are the same in many areas, the patterns
# are where it will differ the most if i am correct.

module CodeRay
module Scanners

class Fancy < Scanner

  register_for :fancy
  file_exstension 'fy'

  autoload :Patterns,    File.expand_path(File.dirname(__FILE__)) + "/coderay/patterns"
  autoload :StringState, File.expand_path(File.dirname(__FILE__)) + "/coderay/string_state"

  def interpreted_string_state
    StringState.new :string, true, ?"
  end

protected

  def setup
    @state = :initial
  end

  def scan_tokens encoder, options
    state, heredocs = options[:state] || @state
    heredocs = heredocs.dup if heredocs.is_a? Array
    
    if state && state.instance_of? StringState
      encoder.begin_group state.type
    end

    last_state = nil

    method_call_expected = false
    value_expected = true

    inline_block_stack = nil
    inline_block_curly_depth = 0

    if heredocs
      state = heredocs.shift
      encoder.begin_group state.type
      heredocs = nil if heredocs.empty?
    end

    patters = Patterns

    unicode = string.respond_to? :encoding && string.encoding.name == 'UTF-8'

    until eos?

      if state.instance_of? ::Symbol

        if match = scan(/[ \t\f\v]+/
    
