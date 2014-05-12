node(:links) do |square|
  @links = [{
    :href => api_v1_board_square_path(@board, square),
    :rel  => "self"
  }]

  @links
end

