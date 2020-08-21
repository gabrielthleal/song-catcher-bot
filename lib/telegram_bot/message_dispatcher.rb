# frozen_String_literal: true

module TelegramBot
  class MessageDispatcher
    attr_reader :message, :user

    def initialize(message, user)
      @message = message
      @user = user
    end

    def process
      if user.next_bot_command

        bot_command = user.next_bot_command.safe_constantize.new(user, message)

        if bot_command.should_start?
          bot_command.start

        else
          unknown_command
        end
      else
        start_command = TelegramBot::Command::Start.new(user, message)

        if start_command.should_start?
          start_command.start
        else
          unknown_command
        end
      end
    end

    private

    def unknown_command
      TelegramBot::Command::Undefined.new(user, message).start
    end
  end
end
