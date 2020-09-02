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
        send_message("Welcome! Send me any song name to add on your spotify playlist \n 
          send /authorize")

        user.reset_next_bot_command

        user.next_bot_command = 'TelegramBot::Command::CatchSong'
      end
    end
  end
end
