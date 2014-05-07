class AddGameIdToBoard < ActiveRecord::Migration
  def change
    add_column :boards, :game_id, :integer, null: false
  end
end
