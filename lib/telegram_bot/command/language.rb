module TelegramBot
  module Command
    class Language < Base
      def should_start?
        true
      end

      def start
        case text
        when /language/
          delete_message
          send_message(I18n.t('telegram.language_txt'), languages)

        when /^(pt|en)$/
          user.update!(language: text)
          answer_callback_query(message[:callback_query], I18n.t('telegram.language_answer'))

        when /menu/
          delete_message
          user.next_bot_command = 'TelegramBot::Command::Start'
          Start.new(user, message).start
        end
      end

      private

      def languages
        {
          with_markup: true,
          inline_keyboard:
          [
            {
              text: 'BR 🇧🇷',
              callback_data: 'pt'
            },
            {
              text: 'EN 🇺🇸',
              callback_data: 'en'
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
