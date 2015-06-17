class GeneralCausaCorte < ActiveRecord::Base
	belongs_to	:corte_causa
	belongs_to	:general_causa
end
