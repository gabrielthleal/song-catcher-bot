class UsersController < ApplicationController
  def spotify
    SpotifyApi::Authorization.new(params[:code], params[:state]).create_user
  end
end
