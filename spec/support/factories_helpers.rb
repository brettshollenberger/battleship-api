module FactoriesHelpers
  def setup_board
    @game  = FactoryGirl.create(:game)

    @p1    = @game.players.first
    @p2    = @game.players.last

    @p1.name = "Brett"
    @p2.name = "Tag"
    @p1.save && @p2.save

    @board = @game.boards.first

    @ship  = @board.ships[4]
    @ship2 = @board.ships[3]
    @ship3 = @board.ships[2]
    @ship4 = @board.ships[1]
    @ship5 = @board.ships[0]

    @sq1 = @board.squares[0]
    @sq2 = @board.squares[1]
    @sq3 = @board.squares[2]
    @sq4 = @board.squares[3]
    @sq5  = @board.squares[4]
    @sq6  = @board.squares[5]
    @sq7  = @board.squares[6]
    @sq8  = @board.squares[7]
    @sq9  = @board.squares[10]
    @sq10 = @board.squares[11]
    @sq11 = @board.squares[12]
    @sq12 = @board.squares[13]
    @sq13 = @board.squares[14]
    @sq14 = @board.squares[15]
    @sq15 = @board.squares[16]
    @sq16 = @board.squares[17]
    @sq17 = @board.squares[18]

    @ship.set([@sq1, @sq2])
    @ship2.set([@sq3, @sq4, @sq5])
    @ship3.set([@sq6, @sq7, @sq8])
    @ship4.set([@sq9, @sq10, @sq11, @sq12])
    @ship5.set([@sq13, @sq14, @sq15, @sq16, @sq17])

    return @board
  end
end
