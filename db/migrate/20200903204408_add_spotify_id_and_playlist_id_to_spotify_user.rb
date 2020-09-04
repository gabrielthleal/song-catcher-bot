class AddSpotifyIdAndPlaylistIdToSpotifyUser < ActiveRecord::Migration[6.0]
  def change
    add_column :spotify_users, :spotify_id, :string
    add_column :spotify_users, :playlist_id, :string
  end
end
