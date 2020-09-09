# frozen_String_literal: true

module TelegramBot
  module Command
    class Base
      attr_reader :user, :message

      def initialize(user, message)
        @user = user
        @message = message
      end

      def start
        raise NotImplementedError
      end

      protected

      def send_message(text, options = {})
        with_markup = options.fetch(:with_markup, false)

        params = { chat_id: @user.telegram_id, text: text, parse_mode: 'Markdown' }
        headers = { content_type: 'application/json' }

        if with_markup
          reply_markup = { reply_markup: reply_keyboard_markup(options[:inline_keyboard]) }
          params.merge!(reply_markup)
        end

        Request.execute(:get, :telegram_api_uri, '/sendMessage', { params: params, headers: headers })
      end

      def delete_message
        message_id = @message.dig(:callback_query, :message, :message_id)

        params = { chat_id: @user.telegram_id, message_id: message_id }
        headers = { content_type: 'application/json' }

        Request.execute(:post, :telegram_api_uri, '/deleteMessage', { params: params, headers: headers })
      end

      def answer_callback_query(callback_query, text)
        TelegramBot::AnswerCallbackQuery.send(callback_query, text)
      end

      def reply_keyboard_markup(buttons)
        { inline_keyboard: [buttons] }.to_json
      end

      def text
        data = @message.dig(:callback_query, :data)

        return data if data.present?

        @message[:message][:text]
      end

      def spotify_user
        @spotify_user ||= @user.spotify_user
      end
    end
  end
end
