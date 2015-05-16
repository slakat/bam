class GeneralCausa < ActiveRecord::Base
	belongs_to 		:causa, polymorphic: true
	
	has_many		:client_causas
	has_many		:clients, through: :client_causas

	has_many		:user_causas
	has_many		:accounts, through: :user_causas

	has_many		:movimientos
	has_many		:retiros
end
