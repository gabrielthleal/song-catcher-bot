# frozen_String_literal: true

module TelegramBot
  module Command
    #
    # <Description>
    #
    class Undefined < Base
      def start
        send_message('Unknown command. Type /start ')

        user.reset_next_bot_command
      end
    end
  end
end
