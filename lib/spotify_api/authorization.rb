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
      params = { grant_type: 'authorization_code', code: @code, redirect_uri: REDIRECT_URI }

      encoded_params = URI.encode_www_form(params)
      debugger
      JSON.parse(RestClient.post(TOKEN_URI, encoded_params, auth_header))
    end

    def create_spotify_user
      tokens = token_response

      spotify_user = SpotifyUser.find_or_initialize_by(user_id: user_id)

      spotify_user.update_attributes!(access_token: tokens['access_token'], refresh_token: tokens['refresh_token'])
    end

    private

    def auth_header
      my_token = Base64.strict_encode64("#{ENV['SPOTIFY_CLIENT_ID']}:#{ENV['SPOTIFY_CLIENT_SECRET']}")

      { Autorization: "Basic #{my_token}" }
    end
  end
end
