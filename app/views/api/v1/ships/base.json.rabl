extends "api/v1/ships/links", :object => @ship, locals: {:ship => @ship, :board => @board}
attributes :id, :kind, :state, :length

node :squares do |ship|
  ship.squares.map do |square|
    partial("api/v1/squares/base", :object => square, :locals => {:game => @game, 
                                                                  :board => @board})
  end
end
