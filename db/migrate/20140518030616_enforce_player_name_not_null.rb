class EnforcePlayerNameNotNull < ActiveRecord::Migration
  def change
    change_column :players, :name, :string, null: false
  end
end
