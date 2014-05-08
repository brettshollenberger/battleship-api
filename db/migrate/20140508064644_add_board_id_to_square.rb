class AddBoardIdToSquare < ActiveRecord::Migration
  def change
    add_column :squares, :game_id, :integer, null: false
  end
end
