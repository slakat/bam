module Api
  module V1
    class RetirosController < ApplicationController

      respond_to :json

      def index
        json = Retiro.all.to_json( :include => :civil_causa )

        render json: json
      end

    end

  end
end