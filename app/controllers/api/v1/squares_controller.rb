module Api
  module V1
    class SquaresController < ApplicationController
      skip_before_filter :verify_authenticity_token
      respond_to :json

      def show
        @square = Square.find(params[:id])
        @board  = @square.board
        @game   = @board.game
        @player = @board.player
      end

      def update
        @square = Square.find(params[:id])
        @board  = @square.board
        @game   = @board.game
        @player = @game.players.find(@game.turn)

        if @square.player != @player && !@square.guessed?
          @square.fire
          @game.toggle_turn
          @actionable = true
          render "show", status: :ok
        end
      end

    private
      def created
        { :json => @game.to_json, status: :created, location: api_v1_game_url(@game) }
      end
    end
  end
end
