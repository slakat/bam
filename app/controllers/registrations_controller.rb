class RegistrationsController < Devise::RegistrationsController
  	after_filter :add_account, only: [:create]

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
		    	account = Account.new params[:user][:account].to_h
		    	if account.valid?
		    		resource.account = account
		    		resource.account.save
		    	else
		    		errors = account.errors.messages
		    		resource.destroy		    		
		    		flash[:notice] = nil
		    		flash[:alert] = errors		    		
		    	end
		    end
		end
end 