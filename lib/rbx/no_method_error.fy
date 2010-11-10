class NoMethodError {
  def method_name {
    match self message -> {
      case /('|`):(.*)'/ -> |matcher|
         matcher[2]
      case /('|`)(.*)'/ -> |matcher2|
         matcher2[2]
      case _ -> self message
    }
  }
}
