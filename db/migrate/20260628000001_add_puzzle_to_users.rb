class AddPuzzleToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :puzzle_last_played_at, :datetime
    add_column :users, :puzzle_plays_today,    :integer, default: 0, null: false
  end
end
