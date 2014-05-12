node(:links) do |board|
  @links = [{
    :href => api_v1_board_path(board),
    :rel  => "get"
  }]

  @links
end

