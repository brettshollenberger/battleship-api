node(:links) do |player|
  @links = [{
    :href => api_v1_game_player_url(@game, player),
    :rel  => "self"
  }]

  if @game.updatable_players.include?(player)
    @links.push({
      :href   => api_v1_game_player_url(@game, player),
      :rel    => "edit",
      :prompt => "Choose a name for #{player.player_number(@game)}"
    })
  end

  @links
end

