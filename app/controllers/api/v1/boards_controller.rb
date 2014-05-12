module Api
  module V1
    class BoardsController < ApplicationController
      skip_before_filter :verify_authenticity_token
      respond_to :json

      def create
        @game  = Game.create
        @games = [@game]
        render "show", status: :created
      end

      def show
        @board   = Board.find(params[:id])
        @game    = @board.game
        @player  = @board.player
        @squares = @board.squares
      end

    private
      def created
        { :json => @game.to_json, status: :created, location: api_v1_game_url(@game) }
      end
    end
  end
end
