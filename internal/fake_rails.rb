module FakeRails
  class Routes
    attr_accessor :paths

    def initialize
      @paths = []
    end

    def draw(&block)
      instance_exec(&block)
    end

    def resources(name)
      @paths = [
        {method: "GET", url: "/#{name}", controller_action: "index", controller_name: name},
        {method: "GET", url: "/#{name}/1", controller_action: "show", controller_name: name},
        {method: "GET", url: "/#{name}/new", controller_action: "new", controller_name: name},
      ]
    end
  end
  class Application
    attr_accessor :routes

    def initialize
      @routes = Routes.new
    end
  end

  def self.application
    @application ||= Application.new
  end
end
