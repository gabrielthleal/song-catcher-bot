#
# <Description>
#
module SpotifyApi
  #
  # <Description>
  #
  class Playlist
    def initialize(spotify_user, uri = nil)
      @spotify_user = spotify_user
      @uri = uri
    end

    def create
      path = "/users/#{@spotify_user.spotify_id}/playlists"

      params = {
        name: 'Telegram',
        description: 'All songs that you have added from telegram',
        public: true
      }

      headers = { authorization: "Bearer #{@spotify_user.access_token}", content_type: 'application/json' }

      @create ||= Request.execute(:post, :spotify_api_uri, path, { params: params, headers: headers })
    end

    def add_item
      params = { uris: @uri }
      headers = { authorization: "Bearer #{@spotify_user.access_token}", content_type: 'application/json' }
      path = "/playlists/#{@spotify_user.playlist_id}/tracks"

      response ||= Request.execute(:post, :spotify_api_uri, path, { params: params, headers: headers })

      return refresh_token if response.dig('error', 'status') == 401

      response
    end

    def refresh_token
      params = { grant_type: 'refresh_token', refresh_token: @spotify_user.refresh_token }
      headers = { authorization: "Basic #{BASIC_AUTH}" }

      response ||= Request.execute(:post, :token_uri, nil, { params: params, headers: headers })

      @spotify_user.update!(access_token: response['access_token'])
    end
  end
end
