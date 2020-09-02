class User < ApplicationRecord
  validates_uniqueness_of :telegram_id
  has_one :spotify_user

  def next_bot_command=(command)
    bot_command_data['command'] = command

    save
  end

  def next_bot_command
    bot_command_data['command']
  end

  def reset_next_bot_command
    self.bot_command_data = {}

    save
  end
end
