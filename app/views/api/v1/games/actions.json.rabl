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
    if @game.updatable_ships.length > 0
      @game.updatable_ships.map do |ship|
        @actions.push({
          :href   => api_v1_board_ship_url(ship.board, ship),
          :rel    => "edit",
          :prompt => "Set ship for #{ship.board.player.player_number(@game)}"
        })
      end
    end

    if @board.lockable?
      @actions.push({
        :href   => api_v1_board_url(@board),
        :rel    => "edit",
        :prompt => "Lock board"
      })
    end
  end

  if @game.play_phase?
    @b = @game.updatable_squares.first.board
    @game.updatable_squares.map do |square|
      @actions.push({
        :href   => api_v1_board_square_url(@b, square),
        :rel    => "edit",
        :prompt => "#{@game.players.find(@game.turn).player_number(@game)}: Fire shot"
      })
    end
  end

  if @game.finished_phase?
    @actions.push({
      :href   => api_v1_games_url,
      :rel    => "create",
      :prompt => "#{@game.players.find(@game.winner).player_number(@game)} Victory! Play Again"
    })
  end

  @actions
end

