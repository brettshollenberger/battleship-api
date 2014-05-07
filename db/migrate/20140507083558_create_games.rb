class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.string :phase, default: :setting_ships

      t.timestamps
    end
  end
end
