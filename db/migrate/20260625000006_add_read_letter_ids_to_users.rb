class AddReadLetterIdsToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :read_letter_ids, :json
  end
end