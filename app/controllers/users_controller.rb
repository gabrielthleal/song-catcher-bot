class UsersController < ApplicationController
  def spotify
    SpotifyApi::Authorization.new(params[:code], params[:state]).create_spotify_user
  end
end
