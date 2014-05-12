node(:href) { |n| api_v1_game_path(@game) }
attributes :id, :phase, :turn

child(:players) do |player|
  extends "api/v1/players/base"
  extends "api/v1/players/links"
end
