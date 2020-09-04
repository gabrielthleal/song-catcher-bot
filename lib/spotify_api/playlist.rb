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
      params = {
        name: 'Telegram',
        description: 'All songs that you have added from telegram',
        public: true
      }.to_json

      begin 
        playlist = RestClient.post("#{SPOTIFY_API_URI}/users/#{@spotify_user.spotify_id}/playlists", params, { Authorization: "Bearer #{@spotify_user.access_token}", 'Content-Type': 'application/json' })
      rescue
        return refresh_token
      end

      JSON.parse(playlist)['id']
    end

    def add_item
      url = URI("https://api.spotify.com/v1/playlists/#{@spotify_user.playlist_id}/tracks")

      params = { uris: @uri }
      url.query = URI.encode_www_form(params)

      https = Net::HTTP.new(url.host, url.port)
      https.use_ssl = true

      request = Net::HTTP::Post.new(url)

      request['Authorization'] = "Bearer #{@spotify_user.access_token}"

      response = https.request(request)

      return true if response.code == '201'

      false
    end

    def refresh_token
      basic_auth = Base64.urlsafe_encode64("#{ENV['SPOTIFY_CLIENT_ID']}:#{ENV['SPOTIFY_CLIENT_SECRET']}")
      params = { grant_type: 'refresh_token', refresh_token: @spotify_user.refresh_token }

      response = RestClient.post(TOKEN_URI, params, { Authorization: "Basic #{basic_auth}" })
      access_token = JSON.parse(response)['access_token']

      @spotify_user.update!(access_token: access_token)

      create
    end
  end
end
