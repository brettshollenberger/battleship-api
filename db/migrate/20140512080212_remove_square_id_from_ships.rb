class RemoveSquareIdFromShips < ActiveRecord::Migration
  def change
    remove_column :ships, :square_id
  end
end
