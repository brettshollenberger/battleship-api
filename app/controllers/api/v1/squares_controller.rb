module Api
  module V1
    class SquaresController < ApplicationController
      skip_before_filter :verify_authenticity_token
      respond_to :json

      def create
      end

      def show
        @square = Square.find(params[:id])
        @board  = @square.board
        @game   = @board.game
        @player = @board.player
      end

    private
      def created
        { :json => @game.to_json, status: :created, location: api_v1_game_url(@game) }
      end
    end
  end
end
