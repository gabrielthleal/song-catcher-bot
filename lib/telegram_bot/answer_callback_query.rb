module TelegramBot
  #
  # MessageDispatcher
  #
  class AnswerCallbackQuery
    private_class_method :new

    def self.send(callback_query, text)
      new(callback_query, text).process
    end

    def initialize(callback_query, text)
      @id = callback_query[:id]
      @telegram_id = callback_query[:from][:id]
      @text = text
    end

    def process
      params = { callback_query_id: @id, text: @text }
      headers = { content_type: 'application/json' }

      Request.execute(:get, :telegram_api_uri, '/answerCallbackQuery', { params: params, headers: headers })
    end
  end
end
