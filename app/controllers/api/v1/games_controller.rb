module Api
  module V1
    class GamesController < ApplicationController
      skip_before_filter :verify_authenticity_token
      respond_to :json

      def create
        @game = Game.create
        render "show", status: :created
      end

      def show
        @game = Game.find(params[:id])
      end

    private
      def created
        { :json => @game.to_json, status: :created, location: api_v1_game_url(@game) }
      end
    end
  end
end
