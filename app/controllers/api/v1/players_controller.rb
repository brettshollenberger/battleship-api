module Api
  module V1
    class PlayersController < ApplicationController
      skip_before_filter :verify_authenticity_token
      respond_to :json

      def update
        @game    = Game.find(params[:game_id])
        @players = Player.where(id: params[:id])
        @player  = @players.first

        render forbidden message: "It is not that player's turn." and return if !@player.turn?(@game)

        if @player.update(player_params)
          @game.sync
          @game.toggle_turn && @actionable = true if @player.setup?
          @board = @player.board
          render "show", status: :ok
        end
      end

      def show
        @player = Player.find(params[:id])
        @game   = Game.find(params[:game_id])
        @board  = @player.board_for(@game)
      end

    private

      def player_params
        params.require(:player).permit(:name)
      end

      def forbidden(message)
        { :json => message, status: :forbidden, message: message }
      end
    end
  end
end
