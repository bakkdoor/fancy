class DynamicSlotObject : Object {
  def unknown_message: m with_params: p {
    slotname = m to_s[[0,-2]]
    value = p first
    set_slot: slotname value: value
  }
}