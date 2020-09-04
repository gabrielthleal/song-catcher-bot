class UsersController < ApplicationController
  def spotify
    SpotifyApi::Authorization.new(params[:code], params[:state]).create_user

    secret_code = Base64.urlsafe_encode64('potato123')

    redirect_to "https://t.me/SongCatcherBot?start=#{secret_code}"
  end
end
