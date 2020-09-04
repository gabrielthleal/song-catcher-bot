module SpotifyApi
  class Search 
    BASIC_AUTH = Base64.urlsafe_encode64("#{ENV['SPOTIFY_CLIENT_ID']}:#{ENV['SPOTIFY_CLIENT_SECRET']}").freeze

    private_class_method :new

    def self.track(song_name, spotify_user)
      new(song_name, spotify_user).find
    end

    def initialize(song_name, spotify_user)
      @song_name = song_name
      @spotify_user = spotify_user
    end

    def find
      params = {  q: @song_name, type: :track }
      headers = { authorization: "Bearer #{@spotify_user.access_token}" }

      response ||= Request.execute(:get, :spotify_api_uri, '/search', { params: params, headers: headers })

      return refresh_token if response.dig('error', 'status') == 401

      response
    end

    private

    def refresh_token
      params = { grant_type: 'refresh_token', refresh_token: @spotify_user.refresh_token }
      headers = { authorization: "Basic #{BASIC_AUTH}" }

      response ||= Request.execute(:post, :token_uri, nil, { params: params, headers: headers })

      @spotify_user.update!(access_token: response['access_token'])
    end
  end
end
