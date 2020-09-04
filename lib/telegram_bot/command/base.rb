# frozen_String_literal: true

module TelegramBot
  module Command
    class Base

      attr_reader :user, :message

      def initialize(user, message)
        @user = user
        @message = message
      end

      def should_start?
        raise NotImplementedError
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

      def reply_keyboard_markup(buttons)
        { inline_keyboard: [[buttons]] }.to_json
      end

      def text
        @message[:message][:text]
      end

      def from
        @message[:message][:from]
      end
    end
  end
end
