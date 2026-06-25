class AddGameFieldsToTasks < ActiveRecord::Migration[7.0]
  def change
    add_column :tasks, :category, :string, default: "その他"
    add_column :tasks, :coin_reward, :integer, default: 10, null: false
  end
end
