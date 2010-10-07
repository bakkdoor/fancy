try {
  try {
    StdError new: "Propagated exception" . raise!
  } catch String => not_matched {
    "Should not enter here" println
  }
} catch Object => anything {
  anything println
}
