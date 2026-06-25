class AddLastBoxPrizeToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :last_box_prize, :json
  end
end
