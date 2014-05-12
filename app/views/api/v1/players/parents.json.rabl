node :game do
  partial "api/v1/games/links", :object => @game, :locals => {:game => @game}
end

