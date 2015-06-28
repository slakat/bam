class Expediente < ActiveRecord::Base
	belongs_to		:corte_causa
	belongs_to		:suprema_causa
end
