class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :telegram_id
      t.string :first_name
      t.string :last_name
      t.jsonb :bot_command_data, default: {}

      t.timestamps null: false
    end
  end
end
