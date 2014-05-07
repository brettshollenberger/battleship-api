class ChangeNameForPlayers < ActiveRecord::Migration
  def change
    change_column :players, :name, :string, null: true
  end
end
