class ClientCausa < ActiveRecord::Base
	belongs_to	:client
	belongs_to	:general_causa
end
