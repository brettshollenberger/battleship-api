node(:links) do |player|
  @links = [{
    :href => api_v1_game_player_path(@game, player),
    :rel  => "get"
  }]

  if @game.updatable_players.include?(player)
    @links.push({
      :href => api_v1_game_player_path(@game, player),
      :rel  => "put"
    })
  end

  @links
end

