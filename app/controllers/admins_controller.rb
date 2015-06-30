class AdminsController < ApplicationController
  authorize_resource :class => false

  def users
    @users = User.all
  end

  def search_records
    @records = SearchRecord.all
  end

  def clients
    @clients = Client.all
  end
end
