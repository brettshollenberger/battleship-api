node(:links) do |board|
  @links = [{
    :href => api_v1_board_url(board),
    :rel  => "self"
  }]

  @links
end

