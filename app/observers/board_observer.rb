class BoardObserver < ActiveRecord::Observer
  observe :board

  def after_locked(board)
    board.game.after_board_locked(board)
  end
end
