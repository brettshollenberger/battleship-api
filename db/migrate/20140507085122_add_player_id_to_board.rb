class AddPlayerIdToBoard < ActiveRecord::Migration
  def change
    add_column :boards, :player_id, :integer, null: false
  end
end
