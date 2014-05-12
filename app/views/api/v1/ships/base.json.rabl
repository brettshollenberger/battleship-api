extends "api/v1/ships/links"

attributes :id, :kind, :state

child(:board) do
  extends "api/v1/boards/links"
end

node :player do
  partial("api/v1/players/links", :object => @player, :locals => {:game => @game, :board => @board, 
                                                                  :player => @player})
end

node :game do
  partial("api/v1/games/links", :object => @game, :locals => {:game => @game})
end
