require "./internal/fake_rails/controller.rb"

class PostsController < FakeRails::Controller
  def index
    @posts = database.transaction { database[:posts] }

    @posts = @posts.map {|p| OpenStruct.new(p)}
  end

  def show
    @post = database.transaction { OpenStruct.new(database[:posts][params[:id].to_i]) }
  end
end
