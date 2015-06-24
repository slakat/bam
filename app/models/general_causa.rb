class GeneralCausa < ActiveRecord::Base
	belongs_to 	:causa, polymorphic: true
	
	has_many		:client_causas
	has_many		:clients, through: :client_causas

	has_many		:user_causas
	has_many		:accounts, through: :user_causas

	
	has_many		:general_causas_cortes, :class_name => "GeneralCausa", foreign_key: :general_causa_id
  belongs_to 	:parent, :class_name => "GeneralCausa" , foreign_key: :general_causa_id

	# has_many		:general_causa_cortes
	# has_many		:corte_causas, through: :general_causa_cortes 

	# has_many		:general_causa_suprema
	# has_many		:suprema_causas, through: :general_causa_suprema


	has_many		:movimientos	
	has_many		:litigantes

	def self.search(q)
		causas_arel      = LaboralCausa.arel_table
		query_string = "%#{q}%"

		causas = LaboralCausa.where((causas_arel[:rit].matches(query_string)).or(causas_arel[:ruc].matches(query_string)).or(causas_arel[:caratulado].matches(query_string)).or(causas_arel[:tribunal].matches(query_string)))
	end

end
