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
        return user.next_bot_command = 'TelegramBot::Command::Start' if start_again?

        return send_message(I18n.t('telegram.authorized')) if should_search?

        return send_message(I18n.t('telegram.authorization'), authorization) if spotify_user.nil?

        send_message(I18n.t('telegram.searching'))

        return send_message(I18n.t('telegram.not_found')) if track.nil?

        send_message("#{I18n.t('telegram.add_song')}#{track['external_urls']['spotify']}", add_song_btn)
      end

      def authorization
        {
          with_markup: true, inline_keyboard:
          {
            text: I18n.t('telegram.authorization_btn'),
            url: SpotifyApi::Authorization.generate_link(user.id)
          }
        }
      end

      def add_song_btn
        {
          with_markup: true, inline_keyboard:
          {
            text: I18n.t('telegram.add_song_btn'),
            callback_data: track['uri']
          }
        }
      end

      def should_search?
        secret_code = Base64.urlsafe_encode64('potato123')

        text.include?(secret_code)
      end

      def start_again?
        text.match?(%r{\A/start})
      end

      def track
        @track ||= SpotifyApi::Search.track(text, spotify_user)

        @track['tracks']['items'][0]
      end

      private

      def spotify_user
        user.spotify_user
      end
    end
  end
end
