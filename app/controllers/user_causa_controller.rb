class UserCausaController < ApplicationController
  before_action :set_user_causa, only: [:update]
  load_and_authorize_resource
  respond_to :html, :json

  def update
  	@user_causa.update(user_causa_params)
    respond_with(@user_causa)
  end

  private
    def set_user_causa
      @user_causa = UserCausa.find(params[:id])
    end

    def user_causa_params
      params.require(:user_causa).permit(:not1, :not2, :not3)
    end
end
