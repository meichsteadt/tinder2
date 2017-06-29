class LoginController < ApplicationController
  def index
    if !authorized?
      session[:access_token] = Like.get_token
      redirect_to likes_path
    end
  end
end
