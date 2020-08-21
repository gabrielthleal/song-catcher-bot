# frozen_String_literal: true

# frozen_String_literal: true

require 'net/http'

module TelegramBot
  module Command
    class Search < Base
      def should_start?
        text.match?(%r{^(https?\:\/\/)?(www\.youtube\.com|youtu\.?be)\/.+$})
      end

      def start
        send_message("The tile of that song is: #{get_title}")

        user.reset_next_bot_command
        
        # search spotify track here
      end

      def get_title
        yt_api_key = ENV['YOUTUBE_API']
        yt_video_id = video_id

        uri = URI("https://www.googleapis.com/youtube/v3/videos?id=#{yt_video_id}&key=#{yt_api_key}&part=snippet")

        res = JSON.parse(Net::HTTP.get(uri))

        res['items'][0]['snippet']['title']
      end

      def video_id
        match = text.match(
          %r{^.*((youtu.be/)|(v/)|(/u/\w/)|(embed/)|(watch\?))\??v?=?([^#\&\?]*).*}
        )

        match[7] if match.size == 8

        'bakamitai kazuma kiryu'
      end
    end
  end
end
