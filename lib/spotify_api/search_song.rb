require 'rest-client'

module SpotifyApi
  class SearchSong 
    SPOTIFY_API_URI = 'https://api.spotify.com/v1'.freeze

    def initialize(song_name, spotify_user)
      @song_name = song_name
      @spotify_user = spotify_user
    end

    def find
      params = { Authorization: "Bearer #{@spotify_user.access_token}", params: { q: @song_name, type: :track } }
      
      JSON.parse(RestClient.get("#{SPOTIFY_API_URI}/search", params))
    end
  end
end
