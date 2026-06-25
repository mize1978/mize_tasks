class AddEggColorToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :egg_color, :string, default: nil
  end
end
