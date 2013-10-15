class TypeConversionMissingError : StandardError {
  read_slots: ('instance, 'target_class)

  def initialize: @instance class: @target_class {
    initialize: "No type conversion handler defined for #{instance} (#{instance class}) to #{target_class}"
  }
}

class InvalidTypeConversionError : StandardError {
  read_slots: ('instance, 'target_class)

  def initialize: @instance class: @target_class {
    initialize: "Invalid type conversion from #{instance} (#{instance class}) to #{target_class}"
  }
}

class Class {
  class TypeConversionBuilder {
    read_slot: 'type_conversions
    def initialize {
      @type_conversions = <[]>
    }

    def to: class with: callable {
      @type_conversions[class]: callable
    }
  }

  lazy_slot: 'type_conversions value: { <[]> }

  def type_convert: block {
    cb = TypeConversionBuilder new
    block call: [cb]
    type_conversions merge!: $ cb type_conversions
  }

  def convert: instance to: class {
    if: (type_conversions[class]) then: @{
      call_with_receiver: instance
    } else: {
      if: (superclass != nil) then: {
        superclass convert: instance to: class
      } else: {
        TypeConversionMissingError new: instance class: class . raise!
      }
    }
  }

  def invalid_conversions: classes {
    classes each: |c| {
      type_convert: @{
        to: c with: {
          InvalidTypeConversionError new: self class: c . raise!
        }
      }
    }
  }
}

class Object {
  def =~> klass {
    class convert: self to: klass
  }

  type_convert: @{
    to: Array   with: 'to_a
    to: Symbol  with: 'to_sym
    to: String  with: 'to_s
    to: Hash    with: 'to_hash
    to: Tuple   with: { Tuple with_values: to_a }
  }
}

class Float {
  invalid_conversions: (Symbol, Hash)
}
