node(:links) do |game|
  @links = [{
    :href => api_v1_game_url(game),
    :rel  => "self"
  }]

  @links
end

