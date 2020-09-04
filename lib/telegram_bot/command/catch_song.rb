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
        return send_message('*Alright! Now you can search.*') if can_search?

        return send_message("Seems to be your first time here.\nYou'll need authorization from Spotify.\nClick on the below link to get one.", { with_markup: true, inline_keyboard: { text: 'Authorization', url: autorization_link } }) if spotify_user.nil?

        send_message('🤖🔎 _Searching..._')

        return send_message('Make sure that the song name is correct and try again') if track.nil?

        send_message("Do you want to add this song?\n#{track['external_urls']['spotify']}", { with_markup: true, inline_keyboard: { text: 'add', callback_data: track['uri'] } })
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
