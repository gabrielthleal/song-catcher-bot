class WebhooksController < ApplicationController
  def callback
    return TelegramBot::AnswerCallbackQuery.new(params[:callback_query]).process if callback_query?

    dispatcher.new(webhook, user).process

    render(nothing: true, head: :ok)
  end

  private

  def callback_query?
    params[:callback_query].present?
  end

  def webhook
    params[:webhook]
  end

  def dispatcher
    TelegramBot::MessageDispatcher
  end

  def from
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
