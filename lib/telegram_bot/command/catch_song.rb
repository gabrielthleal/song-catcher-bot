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
        return send_message(I18n.t('telegram.authorized')) if can_search?

        return send_message(I18n.t('telegram.authorization'), { with_markup: true, inline_keyboard: { text: I18n.t('telegram.authorization_btn'), url: autorization_link } }) if spotify_user.nil?

        send_message(I18n.t('telegram.searching'))

        return send_message(I18n.t('telegram.not_found')) if track.nil?

        send_message("#{I18n.t('telegram.add_song')}#{track['external_urls']['spotify']}", { with_markup: true, inline_keyboard: { text: I18n.t('telegram.add_song_btn'), callback_data: track['uri'] } })
      end

      def autorization_link
        SpotifyApi::Authorization.generate_link(user.id)
      end

      def can_search?
        secret_code = Base64.urlsafe_encode64('potato123')

        text.include?(secret_code)
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
