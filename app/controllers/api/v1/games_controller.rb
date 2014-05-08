module Api
  module V1
    class GamesController < ApplicationController
      skip_before_filter :verify_authenticity_token
      respond_to :json

      def create
        @g = Game.create
        respond_to do |format|
          format.json { render :json => @g.controls }
        end
      end
    end
  end
end
