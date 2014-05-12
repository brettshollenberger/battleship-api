extends "api/v1/players/links"

attributes :name, :id

node :board do
  partial "api/v1/boards/base", :object => @player.board_for(@game), 
    locals: {:game => @game, :player => @player, :board => @player.board_for(@game)}
end
