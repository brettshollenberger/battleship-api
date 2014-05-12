attributes :name, :id

node(:board) do |player|
  partial "api/v1/boards/base", :object => player.board_for(@game) 
end
