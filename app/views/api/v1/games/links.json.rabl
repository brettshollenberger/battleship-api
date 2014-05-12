node(:links) do |game|
  @links = [{
    :href => api_v1_game_path(game),
    :rel  => "self"
  }]

  @links
end

