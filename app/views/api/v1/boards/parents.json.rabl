node :game do
  partial("api/v1/games/links", :object => @game, :locals => {:game => @game})
end

node :player do
  partial("api/v1/players/links", :object => @player, :locals => {:player => @player})
end

