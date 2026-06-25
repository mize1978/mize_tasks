class AddFurnitureToUsers < ActiveRecord::Migration[7.0]
  def change
    # 所持している家具ID / 部屋に配置中の家具ID（JSON配列）
    add_column :users, :owned_furniture, :json
    add_column :users, :placed_furniture, :json
  end
end
