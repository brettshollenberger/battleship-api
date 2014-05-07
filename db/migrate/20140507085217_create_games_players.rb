class CreateGamesPlayers < ActiveRecord::Migration
  def change
    create_table :games_players do |t|
      t.integer :player_id, null: false
      t.integer :game_id, null: false

      t.timestamps
    end
  end
end
