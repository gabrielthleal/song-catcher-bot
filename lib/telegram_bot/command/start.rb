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
        send_message("*Welcome!!*\nThis bot is to search for some songs by name. We'll create a playlist on your _Spotify_ called _Telegram_, you'll find all songs that were added here.\n Go ahead and try to search something.")

        user.reset_next_bot_command

        user.next_bot_command = 'TelegramBot::Command::CatchSong'
      end
    end
  end
end
