try {
  "Hola" println
  StdError new: "Hello" . raise!
  "Hi" println
} catch StdError => e {
  e println
}  finally {
  "Adios" println
}
