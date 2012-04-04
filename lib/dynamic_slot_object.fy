class DynamicSlotObject : Fancy BasicObject {
  def initialize {
    @object = Object new
  }

  def object {
    @object
  }

  def unknown_message: m with_params: p {
    m to_s split: ":" . each_with_index: |slotname idx| {
      @object set_slot: slotname value: $ p[idx]
    }
  }
}

class DynamicKeyHash : Fancy BasicObject {
  def initialize: @deep (false) {
    @hash = <[]>
  }

  def hash {
    @hash
  }

  def unknown_message: m with_params: p {
    m to_s split: ":" . each_with_index: |slotname idx| {
      val = p[idx]
      if: @deep then: {
        match val {
          case Block -> val = val to_hash
        }
      }
      @hash[slotname to_sym]: val
    }
  }
}

class DynamicValueArray : Fancy BasicObject {
  def initialize {
    @arr = []
  }

  def array {
    @arr
  }

  def unknown_message: m with_params: p {
    if: (p size > 0) then: {
      subarr = []
      m to_s split: ":" . each_with_index: |slotname idx| {
        subarr << (slotname to_sym)
        subarr << (p[idx])
      }
      @arr << subarr
    } else: {
      @arr << (m to_s rest to_sym) # skip leading :
    }
    self
  }
}
