module FakeRails
  class Controller
    attr_reader :database, :params

    def initialize(params:)
      @database = YAML::Store.new("database.yml")
      @params = params
    end

    def get_binding
      binding
    end
  end
end
