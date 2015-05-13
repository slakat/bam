class UserCausa < ActiveRecord::Base
	belongs_to	:general_causa
	belongs_to	:account
end
