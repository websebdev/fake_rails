require "socket"
require "uri"
require "yaml/store"
require "erb"
require "ostruct"

require "./internal/fake_rails/dispatcher.rb"
require "./internal/fake_rails/application.rb"
require "./internal/fake_rails/routes.rb"
require "./app/controllers/posts_controller.rb"

module FakeRails
  def self.application
    @application ||= Application.new
  end
end

require "./config/routes.rb"
