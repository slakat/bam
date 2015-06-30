module Api
  module V1
    class RetirosController < ApplicationController

      respond_to :json

      def index
        json = Retiro.all.to_json( :include => :civil_causas )

        render json: json
      end

    end

  end
end