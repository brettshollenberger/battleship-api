attributes :id

node :squares do |board|
  board.squares.map do |square| 
    partial("api/v1/squares/base", :object => square, :locals => {:board => @board, :square => square}) 
  end
end
