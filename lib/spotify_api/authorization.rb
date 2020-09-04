#
# <Description>
#
module SpotifyApi
  #
  # <Description>
  #
  class Authorization
    TOKEN_URI = 'https://accounts.spotify.com/api/token'.freeze
    REDIRECT_URI = 'http://localhost:3000/auth/spotify/callback'.freeze
    AUTHORIZATION_URI = 'https://accounts.spotify.com/authorize'.freeze
    SPOTIFY_API_URI = 'https://api.spotify.com/v1'.freeze

    def initialize(code, user_id)
      @code = code
      @user_id = user_id
    end

    def self.autorization_link(user_id)
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

    def token_response
      basic_auth = Base64.urlsafe_encode64("#{ENV['SPOTIFY_CLIENT_ID']}:#{ENV['SPOTIFY_CLIENT_SECRET']}")
      url = URI(TOKEN_URI)

      params = {
        grant_type: 'authorization_code',
        code: @code,
        redirect_uri: 'http://localhost:3000/auth/spotify/callback'
      }

      url.query = URI.encode_www_form(params)

      https = Net::HTTP.new(url.host, url.port)
      https.use_ssl = true

      request = Net::HTTP::Post.new(url)

      request['Authorization'] = "Basic #{basic_auth}"

      https.request(request)
    end

    def create_spotify_user
      spotify_id = JSON.parse(my_spotify_info)['id']

      spotify_user.update!(access_token: token_response['access_token'],
                           refresh_token: token_response['refresh_token'],
                           spotify_id: spotify_id)

      create_playlist if spotify_user.playlist_id.nil?
    end

    private

    def spotify_user
      @spotify_user ||= SpotifyUser.find_or_initialize_by(user_id: @user_id)
    end

    def my_spotify_info
      debugger
      @my_spotify_info ||= RestClient.get("#{SPOTIFY_API_URI}/me", { Authorization: "Bearer #{token_response['access_token']}" })
    end

    def create_playlist
      playlist_id = SpotifyApi::Playlist.new(spotify_user).playlist_id

      spotify_user.update!(playlist_id: playlist_id)
    end
  end
end
