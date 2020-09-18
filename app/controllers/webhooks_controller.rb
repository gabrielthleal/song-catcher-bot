class WebhooksController < ApplicationController
  def callback
    I18n.locale = user.language

    dispatcher.new(webhook, user).process

    render(nothing: true, head: :ok)
  end

  private

  def webhook
    params[:webhook]
  end

  def callback_query
    webhook[:callback_query]
  end

  def dispatcher
    TelegramBot::MessageDispatcher
  end

  def from
    return callback_query[:from] if callback_query.present?

    webhook[:message][:from]
  end

  def user
    @user ||= User.find_by(telegram_id: from[:id]) || register_user
  end

  def register_user
    @user = User.find_or_initialize_by(telegram_id: from[:id])
    @user.update_attributes!(first_name: from[:first_name], last_name: from[:last_name])

    @user
  end
end
