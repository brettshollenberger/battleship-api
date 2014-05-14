module Api
  module V1
    class ShipsController < ApplicationController
      skip_before_filter :verify_authenticity_token
      respond_to :json

      def show
        @ship   = Ship.find(params[:id])
        @board  = @ship.board
        @game   = @board.game
        @player = @board.player
      end

      def update
        @ship    = Ship.find(params[:id])
        @squares = params[:ship][:squares].map { |s| Square.find(ActiveSupport::JSON.decode(s)["id"]) }
        if @ship.set(@squares)
          @board = @ship.board
          @ship.squares.reload
          render "show", status: :ok
        else
        end
      end

    private
      def ship_params
        params.require(:ship).permit(:squares)
      end

      def created
        { :json => @game.to_json, status: :created, location: api_v1_game_url(@game) }
      end
    end
  end
end
