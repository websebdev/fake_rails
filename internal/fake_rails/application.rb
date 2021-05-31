module FakeRails
  class Application
    attr_accessor :routes

    def initialize
      @routes = Routes.new
    end
  end
end
