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
        send_message(I18n.t('telegram.welcome'))

        user.reset_next_bot_command

        user.next_bot_command = 'TelegramBot::Command::CatchSong'
      end
    end
  end
end
