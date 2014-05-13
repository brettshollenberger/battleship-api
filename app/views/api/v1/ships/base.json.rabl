extends "api/v1/ships/links", :object => @ship, locals: {:ship => @ship, :board => @board}
attributes :id, :kind, :state, :length
