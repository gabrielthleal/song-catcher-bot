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

        # 1 - Criar playlist na autorização.
        # 2 - Evitar criar outra playlist quando autorizar novamente.
        # 3 - melhorar autorização (aparência/funcionamento)
        # 4 mudar tudo pra net/http
        # 5 - refatorar tudo.
        send_message('Catching that song...')

        return send_message('You have no authorization, please, type /authorize to get one') if spotify_user.nil?

        return send_message('Make sure that the song name is correct and try again') if track.nil?

        send_message("Do you want to add this song?\n#{track['external_urls']['spotify']}", { with_markup: true, callback_data: track['uri']})
      end

      def authorize?
        text.match?(%r{\A/authorize})
      end

      def authorize_link
        send_message(SpotifyApi::Authorization.autorization_link(user.id))
      end

      def track
        search = SpotifyApi::SearchSong.new(text, spotify_user).find

        search['tracks']['items'][0]
      end

      private

      def spotify_user
        user.spotify_user
      end
    end
  end
end
