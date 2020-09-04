module SpotifyApi
  class SearchSong
    SPOTIFY_API_URI = 'https://api.spotify.com/v1'.freeze
    TOKEN_URI = 'https://accounts.spotify.com/api/token'.freeze

    def initialize(song_name, spotify_user)
      @song_name = song_name
      @spotify_user = spotify_user
    end

    def find
      params = { Authorization: "Bearer #{@spotify_user.access_token}", params: { q: @song_name, type: :track } }

      begin
        response = RestClient.get("#{SPOTIFY_API_URI}/search", params)
      rescue
        return refresh_token
      end

      JSON.parse(response.body)
    end

    def refresh_token
      basic_auth = Base64.urlsafe_encode64("#{ENV['SPOTIFY_CLIENT_ID']}:#{ENV['SPOTIFY_CLIENT_SECRET']}")
      params = { grant_type: 'refresh_token', refresh_token: @spotify_user.refresh_token }

      response = RestClient.post(TOKEN_URI, params, { Authorization: "Basic #{basic_auth}" })
      access_token = JSON.parse(response)['access_token']

      @spotify_user.update!(access_token: access_token)

      find
    end
  end
end
