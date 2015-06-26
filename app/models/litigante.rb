class Litigante < ActiveRecord::Base
	belongs_to		:general_causa
	

	validates_uniqueness_of :nombre, :scope => :general_causa_id
end
