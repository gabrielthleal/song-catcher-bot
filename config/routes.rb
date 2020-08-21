Rails.application.routes.draw do
  post 'webhooks/telegram_vbc43edbf1614a075954dvd4bfab34l12', to: 'webhooks#callback'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
