# frozen_String_literal: true

module TelegramBot
  #
  # MessageDispatcher
  #
  class MessageDispatcher
    attr_reader :message, :user

    def initialize(message, user)
      @message = message
      @user = user
    end

    #
    # <Description>
    #
    # @return [<Type>] <description>
    #
    def process
      if user.next_bot_command
        bot_command = user.next_bot_command.safe_constantize.new(user, message)

        return bot_command.start if bot_command.should_start?
      else
        start_command = TelegramBot::Command::Start.new(user, message)

        return start_command.start if start_command.should_start?
      end
      unknown_command
    end

    private

    def unknown_command
      TelegramBot::Command::Undefined.new(user, message).start
    end
  end
end
