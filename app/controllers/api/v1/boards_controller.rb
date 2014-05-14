module Api
  module V1
    class BoardsController < ApplicationController
      skip_before_filter :verify_authenticity_token
      before_filter :decode_json, only: [:update]
      respond_to :json

      def show
        @board   = Board.find(params[:id])
        @game    = @board.game
        @player  = @board.player
        @squares = @board.squares
      end

      def update
        @board   = Board.find(params[:id])
        if @board.update(board_params)
          @squares = @board.squares
          @ships   = @board.ships
          @game    = @board.game
          render "show", status: :ok
        end
      end

    private
      def decode_json
        params[:board] = ActiveSupport::JSON.decode(params[:board])
      end

      def board_params
        params.require(:board).permit(:state, square_attributes: [:ship_id])
      end
    end
  end
end
