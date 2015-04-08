class Causa < ActiveRecord::Base
	has_many		:client_causes
	has_many		:clients, through: :client_causes

	has_many		:user_causes
	has_many		:accounts, through: :user_causes

	has_many		:movimientos
	has_many		:retiros
end
