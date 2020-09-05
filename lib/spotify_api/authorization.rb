#
# <Description>
#
module SpotifyApi 
  #
  # <Description>
  #
  class Authorization
    REDIRECT_URI = "#{ENV['SITE_URL']}/auth/spotify/callback".freeze
    AUTHORIZATION_URI = 'https://accounts.spotify.com/authorize'.freeze
    BASIC_AUTH = Base64.urlsafe_encode64("#{ENV['SPOTIFY_CLIENT_ID']}:#{ENV['SPOTIFY_CLIENT_SECRET']}").freeze

    def initialize(code, user_id)
      @code = code
      @user_id = user_id
    end

    def self.generate_link(user_id)
      uri = URI(AUTHORIZATION_URI)

      params = {
        client_id: ENV['SPOTIFY_CLIENT_ID'],
        response_type: :code,
        redirect_uri: REDIRECT_URI,
        scope: 'playlist-modify-public,playlist-modify-private',
        state: user_id
      }

      uri.query = URI.encode_www_form(params)

      uri
    end

    def generate_token
      params = {
        grant_type: 'authorization_code',
        code: @code,
        redirect_uri: "#{ENV['SITE_URL']}/auth/spotify/callback"
      }
      headers = { authorization: "Basic #{BASIC_AUTH}" }

      @generate_token ||= Request.execute(:post, :token_uri, nil, { params: params, headers: headers })
    end

    def create_user
      spotify_id = my_spotify_info['id']

      spotify_user.update!(access_token: generate_token['access_token'],
                           refresh_token: generate_token['refresh_token'],
                           spotify_id: spotify_id)

      generate_playlist if spotify_user.playlist_id.nil?
    end

    private

    def spotify_user
      @spotify_user ||= SpotifyUser.find_or_initialize_by(user_id: @user_id)
    end

    def my_spotify_info
      headers = { authorization: "Bearer #{generate_token['access_token']}" }

      @my_spotify_info ||= Request.execute(:get, :spotify_api_uri, '/me', { headers: headers })
    end

    def generate_playlist
      playlist = Playlist.new(spotify_user).create

      spotify_user.update!(playlist_id: playlist['id'])
    end
  end
end
