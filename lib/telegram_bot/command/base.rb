# frozen_String_literal: true

require 'net/http'
module TelegramBot
  module Command
    #
    # <Description>
    #
    class Base
      attr_reader :user, :message

      TELEGRAM_API_URI = "https://api.telegram.org/bot#{ENV['TELEGRAM_BOT_TOKEN']}"

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
        reply_markup = { reply_markup: reply_keyboard_markup(options[:callback_data]) }
        options.fetch(:with_markup, false)

        params = { chat_id: @user.telegram_id,
                   text: text }

        params.merge!(reply_markup) if options[:with_markup]
        
        RestClient.get("#{TELEGRAM_API_URI}/sendMessage", { params: params })
      end

      def reply_keyboard_markup(data)
        {
          inline_keyboard: [[
            { text: 'add', callback_data: data }
          ]]
        }.to_json
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
