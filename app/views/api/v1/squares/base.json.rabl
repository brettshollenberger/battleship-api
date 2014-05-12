extends "api/v1/squares/links", object: @square, locals: {:square => @square, :board => @board}
attributes :id, :x, :y, :state
