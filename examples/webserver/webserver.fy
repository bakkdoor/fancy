# webserver.fy
# Example of a simple webserver written in fancy, using Ruby socket library

host, port = "127.0.0.1", 3000
webserver = TCPServer new: host port: port
"Webserver running at: #{host}:#{port}" println

loop: {
  session = webserver accept
  Thread new: {
    session print: "HTTP/1.1 200/OK\r\nContent-type:text/html\r\n\r\n"
    session print: $ File read: "examples/webserver/index.html"
    session close
  }
}
