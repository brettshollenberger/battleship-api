extends "api/v1/games/links"
extends "api/v1/games/actions"

attributes :id, :phase, :turn

node :players do |game|
  game.players.map do |player|
    partial("api/v1/players/base", :object => player, :locals => {:game => @game, 
                                                                  :board => player.board_for(@game), 
                                                                  :player => player})
  end
end
