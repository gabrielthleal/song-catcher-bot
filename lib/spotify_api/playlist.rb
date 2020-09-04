#
# <Description>
#
module SpotifyApi
  #
  # <Description>
  #
  class Playlist 
    SPOTIFY_API_URI = 'https://api.spotify.com/v1'.freeze
    TOKEN_URI = 'https://accounts.spotify.com/api/token'.freeze

    def initialize(spotify_user, uri = nil)
      @spotify_user = spotify_user
      @uri = uri
    end

    def playlist_id
      path = "/users/#{@spotify_user.spotify_id}/playlists"

      params = {
        name: 'Telegram',
        description: 'All songs that you have added from telegram',
        public: true
      }

      headers = { authorization: "Bearer #{@spotify_user.access_token}", content_type: 'application/json' }

      playlist = Request.new(:post, :spotify_api_uri, path, { params: params, headers: headers }).execute

      playlist['id']
    end

    def add_item
      params = { uris: @uri }
      headers = { authorization: "Bearer #{@spotify_user.access_token}" }

      Request.new(:post, :spotify_api_uri, nil, { params: params, headers: headers }).execute
    end

    def refresh_token
      basic_auth = Base64.urlsafe_encode64("#{ENV['SPOTIFY_CLIENT_ID']}:#{ENV['SPOTIFY_CLIENT_SECRET']}")
      params = { grant_type: 'refresh_token', refresh_token: @spotify_user.refresh_token }
      headers = { authorization: "Basic #{basic_auth}" }

      response = Request.new(:post, :token_uri, nil, { params: params, headers: headers }).execute

      @spotify_user.update!(access_token: response['access_token'])

      playlist_id
    end
  end
end
