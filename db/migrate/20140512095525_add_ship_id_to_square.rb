class AddShipIdToSquare < ActiveRecord::Migration
  def change
    add_column :squares, :ship_id, :integer
  end
end
