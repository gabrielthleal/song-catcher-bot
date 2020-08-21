# frozen_String_literal: true

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
        send_message('Welcome. Send me a youtube url')

        user.reset_next_bot_command

        user.next_bot_command = 'TelegramBot::Command::Search'
      end
    end
  end
end
