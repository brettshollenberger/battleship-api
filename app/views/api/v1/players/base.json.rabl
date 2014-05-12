attributes :name, :id

extends "api/v1/players/links"

node :game do
  partial("api/v1/games/links", :object => @game, :locals => {:game => @game})
end

node(:board) do
  partial "api/v1/boards/base", :object => @player.board_for(@game), 
    locals: {:game => @game, :player => @player, :board => @player.board_for(@game)}
end
