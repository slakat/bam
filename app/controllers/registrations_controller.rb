class RegistrationsController < Devise::RegistrationsController
  after_filter :add_account 

  def new
    super
  end

  def create
  	super
  end

  def update
    super
  end



  protected

  def add_account
    if resource.persisted? # user is created successfuly
    	abort 123
      resource.accounts.create(attributes_for_account)
    end
 end
end 