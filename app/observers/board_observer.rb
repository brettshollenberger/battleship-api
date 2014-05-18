class BoardObserver < ActiveRecord::Observer
  observe :board

  def after_state=(board)
    board.game.toggle_turn if board.locked?
  end
end
