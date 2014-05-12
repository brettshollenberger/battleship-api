extends "api/v1/squares/links"

attributes :id, :x, :y, :state

child(:board) do
  extends "api/v1/boards/links"
end

child(:game) do
  extends "api/v1/games/links"
end
