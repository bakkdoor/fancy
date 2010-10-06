try {
  StdError new: "Hello" . raise!
} catch StdError => e { 
  e println
}  
