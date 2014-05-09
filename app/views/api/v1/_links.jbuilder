json.links do 
  if @game.setup_player_phase?
    json.players @game.updatable_players do |player|
      json.rel "edit"
      json.name "player"
      json.href "/api/v1/players/#{player.id}"
      json.prompt "Name player"
    end
  end

  if @game.setup_ship_phase?
    json.ships @game.updatable_ships do |ship|
      json.rel "edit"
      json.name "ship"
      json.href "/api/v1/ships/#{ship.id}"
      json.prompt "Set ship"
    end
  end

  if @game.play_phase?
    json.squares @game.updatable_squares do |square|
      json.rel "edit"
      json.name "square"
      json.href "/api/v1/squares/#{square.id}"
      json.prompt "Guess square"
    end
  end
end
