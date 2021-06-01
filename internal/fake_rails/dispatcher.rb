require "./internal/fake_rails.rb"

module FakeRails
  class Dispatcher
    attr_accessor :params

    def initialize(request_line:)
      @request_line = request_line
      @params = {}
    end

    def http_response
      if current_path
        status_code = "200 OK"

        controller = Kernel.const_get("#{controller_name.capitalize}Controller").new(params: params)
        controller.send(controller_action)

        body = erb_view.result(controller.get_binding)
      else
        status_code = "404 NOT FOUND"
        body = "<b>Didn't hit any endpoint</b>"
      end

      puts status_code

      <<~MSG
        HTTP/1.1 #{status_code}
        Content-Type: text/html
        location: /show/data

        #{body}
      MSG
    end

    private

    def controller_name
      current_path[:controller_name]
    end

    def controller_action
      current_path[:controller_action]
    end

    def current_path
      return @current_path if @current_path

      @current_path = paths.find { |path| path[:method] == request_method && path[:url] == request_url_with_params }
    end

    def paths
      FakeRails.application.routes.paths
    end

    def request_method
      @request_line.split[0]
    end

    def request_url_with_params
      return @request_url_with_params if @request_url_with_params

      # update params to correctly match paths with keywords, ex. /posts/2 to /posts/:id
      url_parts = request_url.split("/")
      paths.each do |path|
        path_url_parts = path[:url].split("/")
        path_url_parts.each.with_index do |part, index|
          if part.start_with?(":") && url_parts[index]
            params[part.sub(":", "").to_sym] = url_parts[index]
            url_parts[index] = part
          end
        end
      end

      @request_url_with_params = url_parts.join("/")
    end

    def request_url
      @request_url ||= @request_line.split[1]
    end

    def request_version_number
      @request_line.split[2]
    end

    def erb_view
      file_content = File.read("./app/views/#{controller_name}/#{controller_action}.html.erb")
      body = ERB.new(file_content)
    end
  end
end
