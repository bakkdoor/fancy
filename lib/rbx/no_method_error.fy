class NoMethodError {
  def method_name {
    match self message -> {
      case /':(.*)'/ -> |matcher|
         matcher[1]
      case /'(.*)'/ -> |matcher2|
         matcher2[1]
      case _ -> self message
    }
  }
}
