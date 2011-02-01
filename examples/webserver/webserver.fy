# webserver.fy
# Example of a simple webserver written in fancy, using Ruby socket library

require("socket")
host = "127.0.0.1"
port = 3000
webserver = TCPServer new(host, port)
"Webserver running at: #{host}:#{port}" println
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
