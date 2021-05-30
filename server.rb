require "socket"
require "uri"
require "yaml/store"
require "erb"
require "ostruct"

require "./internal/fake_rails.rb"
require "./config/routes.rb"



p FakeRails.application.routes.paths

server = TCPServer.new(3000)

require "./app/controllers/posts_controller.rb"

loop do
  client = server.accept

  # Accept a HTTP request and parse it
  request_line = client.readline
  method_token, target, version_number = request_line.split
  puts "✅ Received a #{method_token} request to #{target} with #{version_number}"

  current_path = FakeRails.application.routes.paths.find {|path| path[:method] == method_token && path[:url] == target}

  # Decide what to respond
  if current_path
    controller_name = current_path[:controller_name]
    controller_action = current_path[:controller_action]

    status_code = "200 OK"
    file_content = File.read("./app/views/#{controller_name}/#{controller_action}.html.erb")
    controller = Kernel.const_get("#{controller_name.capitalize}Controller").new
    controller.send(controller_action)

    response_message = ERB.new(file_content).result(controller.get_binding)
  else
    status_code = "404 NOT FOUND"
    response_message = "<b>Didn't hit any endpoint</b>"
  end

  http_response = <<~MSG
    HTTP/1.1 #{status_code}
    Content-Type: text/html
    location: /show/data

    #{response_message}
  MSG

  client.puts(http_response)

  client.close
end
