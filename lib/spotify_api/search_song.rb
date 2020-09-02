require 'rest-client'

module SpotifyApi
  class SearchSong 
    SPOTIFY_API_URI = 'https://api.spotify.com/v1'.freeze

    def initialize(song_name, spotify_user)
      @song_name = song_name
      @spotify_user = spotify_user
    end

    def find
      params = { q: encoded_song, type: :track }
      RestClient.get("#{SPOTIFY_API_URI}/search", params, auth_header)
    end

    private

    def auth_header
      { Authorization: "Bearer #{@spotify_user.access_token}" }
    end

    def encoded_song
      URI.encode_www_form(@song_name)
    end
  end
end
