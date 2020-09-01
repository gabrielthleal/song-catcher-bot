# frozen_String_literal: true
require 'net/http'
module TelegramBot
  module Command
    #
    # <Description>
    #
    class Start < Base
      def should_start?
        text.match?(%r{\A/start})
      end

      def start
        send_message('Welcome!')

        user.reset_next_bot_command
      end
    end
  end
end
