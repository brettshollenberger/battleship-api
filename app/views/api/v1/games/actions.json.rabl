node(:actions) do |game|
  @actions = []

  if @game.setup_player_phase?
    @game.updatable_players.map do |player|
      @actions.push({
        :href   => api_v1_game_player_url(@game, player),
        :rel    => "edit",
        :prompt => "Choose a name for #{player.player_number(@game)}"
      })
    end
  end

  if @game.setup_ship_phase?
    @game.updatable_ships.map do |ship|
      @actions.push({
        :href   => api_v1_board_ship_url(ship.board, ship),
        :rel    => "edit",
        :prompt => "Set ship for #{ship.board.player.player_number(@game)}"
      })
    end
  end


  @actions
end

