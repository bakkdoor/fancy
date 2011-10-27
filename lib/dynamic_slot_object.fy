class DynamicSlotObject : Object {
  def unknown_message: m with_params: p {
    m to_s split: ":" . each_with_index: |slotname idx| {
      set_slot: slotname value: $ p[idx]
    }
  }
}