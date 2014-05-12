module Api
  module V1
    class ShipsController < ApplicationController
      skip_before_filter :verify_authenticity_token
      respond_to :json

      def create
      end

      def show
        @ship   = Ship.find(params[:id])
        @board  = @ship.board
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
