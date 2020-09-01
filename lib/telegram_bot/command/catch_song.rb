# frozen_String_literal: true
module TelegramBot
  module Command
    #
    # <Description>
    #
    class CatchSong < Base
      def should_start?
        true
      end

      def start
        send_message('Catching that song...')
        # TODO: search that song on spotify and return the it.
      end
    end
  end
end
