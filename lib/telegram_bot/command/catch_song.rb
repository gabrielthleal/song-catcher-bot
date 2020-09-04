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
        return send_message("Let's authorizate you first. Click below", { with_markup: true, inline_keyboard: { text: 'Authorization', url: autorization_link } }) if spotify_user.nil?

        send_message('Catching that song...')

        return send_message('Make sure that the song name is correct and try again') if track.nil?

        send_message("Do you want to add this song?\n#{track['external_urls']['spotify']}", { with_markup: true, inline_keyboard: { text: 'add', callback_data: track['uri'] } })
      end

      def autorization_link
        SpotifyApi::Authorization.generate_link(user.id)
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
