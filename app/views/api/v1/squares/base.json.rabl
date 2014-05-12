node(:href) { |n| api_v1_board_square_path(@board, @square) }

attributes :id, :x, :y, :state, :board_id, :game_id

child(:board) do
  extends "api/v1/boards/links"
end

child(:game) do
  extends "api/v1/games/links"
end
