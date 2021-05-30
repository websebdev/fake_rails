module FakeRails
  class Controller
    attr_reader :database
    def initialize
      @database = YAML::Store.new("database.yml")
    end

    def get_binding
      binding
    end
  end
end
