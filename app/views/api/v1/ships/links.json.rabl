node(:links) do |ship|
  @links = [{
    :href => api_v1_board_ship_path(@board, ship),
    :rel  => "self"
  }]

  @links
end

