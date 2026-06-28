class AddPuzzleCollectionToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :puzzle_clears_count, :integer, default: 0, null: false
    add_column :users, :selected_puzzle_id,  :integer, default: 1, null: false
  end
end
