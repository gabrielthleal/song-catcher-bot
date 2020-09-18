# frozen_String_literal: true
module TelegramBot
  module Command
    #
    # <Description>
    #
    class Start < Base
      def should_start?
        true
      end

      def start
        delete_message

        case text
        when %r{\A/start|menu}
          send_message(I18n.t('telegram.welcome'), menu_options)

        when /^(language|pt-br|en)$/
          user.next_bot_command = 'TelegramBot::Command::Language'
          Language.new(user, message).start

        when /authorize/
          user.next_bot_command = 'TelegramBot::Command::Authorize'
          Authorize.new(user, message).start

        when /catch/
          send_message(I18n.t('telegram.can_search'))
          user.next_bot_command = 'TelegramBot::Command::CatchSong'
        end
      end

      private

      def menu_options
        buttons = {
          with_markup: true,
          inline_keyboard:
          [
            {
              text: I18n.t('telegram.language_btn'),
              callback_data: 'language'
            },
            {
              text: I18n.t('telegram.authorization_btn'),
              callback_data: 'authorize'
            }
          ]
        }

        return buttons unless spotify_user.present?

        buttons[:inline_keyboard].push({ text: I18n.t('telegram.search_song_btn'), callback_data: 'catch' })

        buttons
      end
    end
  end
end
