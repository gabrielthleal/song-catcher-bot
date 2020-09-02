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

      def send_message(text)
        uri = URI("#{TELEGRAM_API_URI}/sendMessage")
        params = { chat_id: @user.telegram_id, text: text }
        uri.query = URI.encode_www_form(params)

        Net::HTTP.get(uri)
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
