node(:links) do |square|
  @links = [{
    :href => api_v1_board_square_url(@board, square),
    :rel  => "self"
  }]

  @links
end

