require "./internal/fake_rails.rb"

server = TCPServer.new(3000)

loop do
  client = server.accept

  request_line = client.readline

  http_response = FakeRails::Dispatcher.new(request_line: request_line).http_response

  client.puts(http_response)

  client.close
end
