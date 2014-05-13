class AddStateToBoard < ActiveRecord::Migration
  def change
    add_column :boards, :state, :string, default: "unlocked"
  end
end
