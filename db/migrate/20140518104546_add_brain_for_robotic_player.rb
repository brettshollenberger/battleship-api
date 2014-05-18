class AddBrainForRoboticPlayer < ActiveRecord::Migration
  def change
    add_column :players, :brain, :string
  end
end
