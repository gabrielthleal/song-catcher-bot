class UsersController < ApplicationController
  def spotify
    SpotifyApi::Authorization.new(params[:code], params[:state]).create_user

    redirect_to 'https://t.me/SongCatcherBot?start'
  end
end
