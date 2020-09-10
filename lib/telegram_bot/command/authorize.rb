module TelegramBot
  module Command
    class Authorize < Base
      def should_start?
        true
      end

      def start
        delete_message

        if text.match?(/authorize/)
          send_message(I18n.t('telegram.authorization'), authorization)
        elsif text.downcase.match?(/menu/)
          Start.new(user, message).start
        end

        user.next_bot_command = 'TelegramBot::Command::Start'
      end

      private

      def authorization
        {
          with_markup: true,
          inline_keyboard:
          [
            {
              text: I18n.t('telegram.authorization_btn'),
              url: SpotifyApi::Authorization.generate_link(user.id)
            },
            {
              text: '<< Menu',
              callback_data: 'menu'
            }
          ]
        }
      end
    end
  end
end
