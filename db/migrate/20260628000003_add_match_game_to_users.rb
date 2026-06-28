class AddMatchGameToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :match_game_last_played_at, :datetime
    add_column :users, :match_game_high_score,     :integer, default: 0, null: false
  end
end
