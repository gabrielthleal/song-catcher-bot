class CreateSpotifyUser < ActiveRecord::Migration[6.0]
  def change
    create_table :spotify_users do |t|
      t.string :access_token
      t.string :refresh_token
      t.references :user, null: false, foreign_key: true
    end
  end
end
