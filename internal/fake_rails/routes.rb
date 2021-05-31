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
        {method: "GET", url: "/#{name}/:id", controller_action: "show", controller_name: name},
        {method: "GET", url: "/#{name}/new", controller_action: "new", controller_name: name},
      ]
    end
  end
end
