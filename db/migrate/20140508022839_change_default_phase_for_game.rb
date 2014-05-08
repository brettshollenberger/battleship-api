class ChangeDefaultPhaseForGame < ActiveRecord::Migration
  def change
    change_column :games, :phase, :string, default: :setup_players
  end
end
