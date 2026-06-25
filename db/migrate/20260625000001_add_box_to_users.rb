class AddBoxToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :last_box_opened_at, :datetime
  end
end
