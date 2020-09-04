module TelegramBot
  #
  # MessageDispatcher
  #
  class AnswerCallbackQuery
    def initialize(callback_query)
      @id = callback_query[:id]
      @spotify_uri = callback_query[:data]
      @telegram_id = callback_query[:from][:id]
    end

    def spotify_user
      user = User.find_by(telegram_id: @telegram_id)
      SpotifyUser.find_by(user_id: user.id)
    end

    def process
      SpotifyApi::Playlist.new(spotify_user, @spotify_uri).add_item

      params = { callback_query_id: @id, text: 'Successfully added' }
      headers = { content_type: 'application/json' }

      Request.new(:get, :telegram_api_uri, '/answerCallbackQuery', { params: params, headers: headers }).execute
    end
  end
end
