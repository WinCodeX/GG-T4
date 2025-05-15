class UsersController < ApplicationController

  def index
    @users = User.all
  end
  
  def search
    @users = User.where("username ILIKE ?", "%#{params[:query]}%").limit(10)

    render turbo_stream: turbo_stream.replace(
  "search_results",
  partial: "users/search_results",
  locals: { users: @users }
)
      end
    end

  