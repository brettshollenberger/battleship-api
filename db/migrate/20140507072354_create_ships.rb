class CreateShips < ActiveRecord::Migration
  def change
    create_table :ships do |t|
      t.integer :board_id, null: false
      t.string :type, null: false
      t.integer :square_id
      t.string :state, default: :unset

      t.timestamps
    end
  end
end
