class Litigante < ActiveRecord::Base
	belongs_to		:general_causa
	validates			:name, true
end
