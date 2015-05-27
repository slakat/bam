class GeneralCausa < ActiveRecord::Base
	belongs_to 		:causa, polymorphic: true
	
	has_many		:client_causas
	has_many		:clients, through: :client_causas

	has_many		:user_causas
	has_many		:accounts, through: :user_causas

	has_many		:movimientos
	has_many		:retiros


	def self.search(q)
		causas_arel      = LaboralCausa.arel_table
		query_string = "%#{q}%"

		causas = LaboralCausa.where((causas_arel[:rit].matches(query_string)).or(causas_arel[:ruc].matches(query_string)).or(causas_arel[:caratulado].matches(query_string)).or(causas_arel[:tribunal].matches(query_string)))
	end

end
