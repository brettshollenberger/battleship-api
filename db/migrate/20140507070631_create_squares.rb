class CreateSquares < ActiveRecord::Migration
  def change
    create_table :squares do |t|
      t.integer :x, null: false
      t.integer :y, null: false
      t.string :state, default: :empty
      t.integer :board_id, null: false

      t.timestamps
    end
  end
end
