module TelegramBot
  module Command
    class Undefined < Base
      def start
        send_message('Unknown command. Type /start ')
      end
    end
  end
end
