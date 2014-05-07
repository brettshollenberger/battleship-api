class RemoveBoardAndGameIdFromPlayer < ActiveRecord::Migration
  def change
    remove_column :players, :game_id
    remove_column :players, :board_id
  end
end
