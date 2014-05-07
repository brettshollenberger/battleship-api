class ChangeSquareXAndYToString < ActiveRecord::Migration
  def change
    change_column :squares, :x, :string, null: false
    change_column :squares, :y, :string, null: false
  end
end
