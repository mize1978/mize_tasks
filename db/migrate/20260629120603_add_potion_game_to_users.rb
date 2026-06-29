class AddPotionGameToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :potion_game_last_played_at, :datetime
    add_column :users, :potion_game_high_stage, :integer
  end
end
