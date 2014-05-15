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
        @board = Board.find(params[:id])
        set_ships && params[:board].delete(:ships) && params[:board].delete(:squares)

        if @board.update(board_params)
          @squares    = @board.squares
          @ships      = @board.ships
          @game       = @board.game
          @actionable = true
          @game.toggle_turn if @board.locked?
          render "show", status: :ok
        end
      end

    private
      def decode_json
        begin
          params[:board] = ActiveSupport::JSON.decode(params[:board])
        rescue
        end
      end

      def group_squares_by_ship_id
        return [] if params[:board][:squares] == nil

        params[:board][:squares].select     { |sq| sq[:ship_id] != nil        }
                                .group_by   { |sq| sq[:ship_id]               }
                                .inject({}) do |h,(k,v)| 
                                  h[k] = v.map { |sq| Square.find(sq[:id]) }; h
                                end
      end

      def set_ships
        group_squares_by_ship_id.each do |ship_id, squares|
          @board.ships.find(ship_id).set(squares)
        end
      end

      def board_params
        params.require(:board).permit(:state, 
                                      ship_attributes: [:squares],
                                      square_attributes: [:ship_id])
      end
    end
  end
end
