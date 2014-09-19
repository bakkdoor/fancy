# encoding: utf-8
module CodeRay
  module Scanners

    # Fancy scanner by swarley.
    class Fancy < Scanner

      register_for :fancy
      file_extension 'fy'

      SPECIAL_FORMS = %w[
        self super return return_local def class
        throw try catch finally retry match case
      ]  # :nodoc:

      CORE_FORMS = %w[
        + - > < == != >= <= % ** * = && || =~
      ]  # :nodoc:

      PREDEFINED_CONSTANTS = %w[
        true false nil
      ]  # :nodoc:

      IDENT_KIND = WordList.new(:ident).
        add(SPECIAL_FORMS, :keyword).
        add(CORE_FORMS, :keyword).
        add(PREDEFINED_CONSTANTS, :predefined_constant)

      KEYWORD_NEXT_TOKEN_KIND = WordList.new(nil).
        add(%w[ def ], :function).
        add(%w[ class ], :class)

      BASIC_IDENTIFIER = /[a-zA-Z$%*\/_+!?&<>\-=]=?[a-zA-Z0-9$&*+!\/_?<>\-\#]*/
      CLASS_IDENTIFIER = /[A-Z]+[A-Za-z0-9]*|[A-Z]+[A-Za-z0-9]\:\:|\:\:[A-Z]+[A-Za-z0-9]*/
      IDENTIFIER = /(?!-\d)(?:(?:#{BASIC_IDENTIFIER}\.)*#{BASIC_IDENTIFIER}(?:\/#{BASIC_IDENTIFIER})?\.?)|\.\.?/
      SYMBOL = /\'[A-z0-9\:\!\%\^\&\*\_\-\+\=\|\?\\\/\>\<\~\.]+/o
      DIGIT = /\d+/
      DIGIT10 = DIGIT
      DIGIT16 = /[0-9a-f]/i
      DIGIT8 = /[0-7]/
      DIGIT2 = /[01]/
      DECIMAL = /#{DIGIT}\.#{DIGIT}|-#{DIGIT}\.#{DIGIT}/
      NUM = /(?:\-)*(?:#{DIGIT}|#{DIGIT16}|#{DIGIT8}|#{DIGIT2}|#{DECIMAL})/
      MESSAGE = /[A-Za-z0-9\&\_]+?(?:\:|\?\:)/
      CAPTURE = /\|.+?\|/

      protected

      def scan_tokens(encoder, options)
        state = :initial
        kind = nil

        until eos?
          case state
          when :initial
            if match = scan(/ \s+ | \n | , /x)
              encoder.text_token match, :space
            elsif match = scan(/\#.+?$/)
              encoder.text_token match, :comment
            elsif match = scan(/\{|\}|\@\{|\[|\]|\(|\)/)
              encoder.text_token match, :operator
            elsif match = scan(Regexp.new((%W(+ - @ > < == != >= <= % ** * = && || =~).map {|x| Regexp.escape x }).join '|'))
              encoder.text_token match, :operator
            elsif match = scan(/\:\:/)
              encoder.text_token match, :constant
            elsif match = scan(/\.|\$|\:/)
              encoder.text_token match, :predefined_constant
            elsif match = scan(CAPTURE)
              encoder.text_token match, :predefined_constant
            elsif match = scan(CLASS_IDENTIFIER)
              encoder.text_token match, :constant
            elsif match = scan(MESSAGE)
              encoder.text_token match, :keyword
            elsif match = scan(/#{IDENTIFIER}/o)
              kind = IDENT_KIND[match]
              encoder.text_token match, kind
              if rest? && kind == :keyword
                if kind = KEYWORD_NEXT_TOKEN_KIND[match]
                  encoder.text_token match, :space if match = scan(/\s+/o)
                  encoder.text_token match, kind if match = scan(/#{IDENTIFIER}/o)
                end
              end
            elsif match = scan(MESSAGE)
              encoder.text_token match, :keyword
            elsif match = scan(/#{SYMBOL}/o)
              encoder.text_token match, :symbol
            elsif match = scan(/\./)
              encoder.text_token match, :operator
            elsif match = scan(/ \# \^ #{IDENTIFIER} /ox)
              encoder.text_token match, :type
            elsif match = scan(/ (\#)? " /x)
              state = self[1] ? :regexp : :string
              encoder.begin_group state
              encoder.text_token match, :delimiter
            elsif match = scan(/#{NUM}/o) and not matched.empty?
              encoder.text_token match, match[/[.e\/]/i] ? :float : :integer
            else
              encoder.text_token getch, :error
            end

          when :string, :regexp
            if match = scan(/[^"\\]+|\\.?/)
              encoder.text_token match, :content
            elsif match = scan(/"/)
              encoder.text_token match, :delimiter
              encoder.end_group state
              state = :initial
            else
              raise_inspect "else case \" reached; %p not handled." % peek(1),
                encoder, state
            end
          else
            raise 'else case reached'
          end
        end

        if [:string, :regexp].include? state
          encoder.end_group state
        end

        encoder
      end
    end
  end
end
