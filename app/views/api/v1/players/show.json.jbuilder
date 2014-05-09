json.collection do
  json.version 1
  json.href api_v1_game_players_path(@game)
  json.items @players do
    json.href api_v1_game_player_path(@game, @players.first)
    json.data @player.attributes do |value|
      json.name  value[0]
      json.value value[1]
      json.prompt value[0].humanize
    end
  end
end

json.partial! 'api/v1/links', game: @game
