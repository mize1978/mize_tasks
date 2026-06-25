class AddGameStatsToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :coins, :integer, default: 0, null: false
    add_column :users, :lives, :integer, default: 5, null: false
  end
end
