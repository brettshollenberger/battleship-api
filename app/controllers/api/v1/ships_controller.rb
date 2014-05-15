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
        @squares = squares_json.map { |s| Square.find(s["id"]) }
        if @ship.set(@squares)
          @board = @ship.board
          @game  = @board.game
          @ship.squares.reload
          @actionable = true
          render "show", status: :ok
        else
          render forbidden errors: @ship.errors
        end
      end

    private
      def ship_params
        params.require(:ship).permit(:squares)
      end

      def squares_json
        params[:ship][:squares].map { |s| json_method(s) }
      end

      def json_method(sq)
        begin
          ActiveSupport::JSON.decode(sq)
        rescue
          sq
        end
      end

      def created
        { :json => @game.to_json, status: :created, location: api_v1_game_url(@game) }
      end

      def forbidden(errors)
        { :json => errors, status: :forbidden, errors: errors }
      end
    end
  end
end
