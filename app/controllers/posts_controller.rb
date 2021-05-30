require "./internal/fake_rails/controller.rb"

class PostsController < FakeRails::Controller
  def index
    @posts = []
    database.transaction do
      @posts = database[:posts]
    end

    @posts = @posts.map {|p| OpenStruct.new(p)}
  end

  def show
    database.transaction do
      @post = OpenStruct.new(database[:posts][0])
    end
  end
end
