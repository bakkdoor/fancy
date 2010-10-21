require("socket")
webserver = TCPServer new("127.0.0.1", 3000)
loop: {
  session = webserver accept
  session print: "HTTP/1.1 200/OK\r\nContent-type:text/html\r\n\r\n"
  request = session readln
  filename = "examples/webserver/index.html"
  displayfile = File open(filename, "r")
  content = displayfile read
  session print: content
  session close
}
