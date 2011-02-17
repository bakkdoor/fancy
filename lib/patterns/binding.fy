class Binding {
  read_write_slots: ['value]

  def initialize: @value {
  }

  def bound? {
    @value nil? not
  }
}