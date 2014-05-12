extends "api/v1/boards/links"

attributes :id

node :game do
  partial("api/v1/games/links", :object => @game, :locals => {:game => @game})
end

node :player do
  partial("api/v1/players/links", :object => @player, :locals => {:player => @player})
end

node :ships do
  @board.ships.map do |ship| 
    partial("api/v1/ships/base", :object => ship, :locals => {:board => @board, :ship => ship}) 
  end
end

node :squares do
  @board.squares.map do |square| 
    partial("api/v1/squares/base", :object => square, :locals => {:board => @board, :square => square}) 
  end
end
