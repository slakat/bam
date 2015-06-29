class Retiro < ActiveRecord::Base
	belongs_to		:civil_causa

	validates :cuaderno, :uniqueness => {:scope => [:data_retiro, :civil_causa_id]}
end
