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
        case text
        when /Menu|menu/
          user.next_bot_command = 'TelegramBot::Command::Start'
          Start.new(user, message).start

        when /spotify:track/
          SpotifyApi::Playlist.new(spotify_user, text).add_item

          answer_callback_query(message[:callback_query], I18n.t('telegram.callback_answer'))
        else
          return send_message(I18n.t('telegram.not_found')) if track.nil?

          # TODO: to add nedd auth
          send_message("#{I18n.t('telegram.add_song')}#{track['external_urls']['spotify']}", add_song_btn)
        end
      end

      def add_song_btn
        {
          with_markup: true,
          inline_keyboard:
          [
            {
              text: I18n.t('telegram.add_song_btn'),
              callback_data: track['uri']
            },
            {
              text: '<< Menu',
              callback_data: 'menu'
            }
          ]
        }
      end

      def track
        @track ||= SpotifyApi::Search.track(text, spotify_user)

        @track['tracks']['items'][0]
      end
    end
  end
end
