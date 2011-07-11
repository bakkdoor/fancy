1 match: {
  case: /f(.*)$/ do: |_, m| {
    m match: {
      case: "oo" do: { "yooo" println }
      case: "aa" do: { "woot" println }
      else: { "none" println }
    }
  }

  case: Fixnum do: {
    "a fixnum!" println
  }

  case: _ do: {
    "haha!" println
  }

  else: {
    "no idea." println
  }
}