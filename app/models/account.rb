class Account < ActiveRecord::Base
	belongs_to		:user

	has_many		:user_causes
	has_many		:causas, through: :user_causes
	has_many		:searches
end
