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
        return authorize_link if authorize?

        send_message('Catching that song...')

        return send_message('You have no authorization, please, type /authorize to get one') if spotify_user.nil?

        search = SpotifyApi::SearchSong.new(text, spotify_user).find
        
        send_message(search['tracks']['items'][0]['external_urls']['spotify'])
      end

      def authorize?
        text.match?(%r{\A/authorize})
      end

      def authorize_link
        send_message(SpotifyApi::Authorization.autorization_link(user.id))
      end

      private

      def spotify_user
        user.spotify_user
      end
    end
  end
end
