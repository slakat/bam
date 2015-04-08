class Client < ActiveRecord::Base
	has_many		:client_causes
	has_many		:causas, through: :client_causes
end
