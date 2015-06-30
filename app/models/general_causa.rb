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

	has_many		:causa_changes	
	has_many		:movimientos	
	has_many		:litigantes


	def as_json(options={})
		{ :id => self.id,
			:real_id => self.causa.id,
			:identificator => self.causa.identificator,
			:tribunal => self.causa.tribunal,
			:caratulado => self.causa.caratulado
		}

	end

	def self.search(q,civil,laboral,procesal,corte,suprema)
		query_string = "%#{q}%"
		r_lab,r_civ,r_pro,r_cor,r_sup = []

		if laboral
			causas_arel      = LaboralCausa.arel_table
			causas = LaboralCausa.where((causas_arel[:rit].matches(query_string)).or(causas_arel[:ruc].matches(query_string)).or(causas_arel[:caratulado].matches(query_string)).or(causas_arel[:tribunal].matches(query_string)))

			r_lab = causas.map { |a| a.general_causa }
		end

		if civil
			causas_arel      = CivilCausa.arel_table
			causas = CivilCausa.where((causas_arel[:rol].matches(query_string)).or(causas_arel[:caratulado].matches(query_string)).or(causas_arel[:tribunal].matches(query_string)))
			r_civ = causas.map { |a| a.general_causa }
		end

		if procesal
			causas_arel      = ProcesalCausa.arel_table
			causas = ProcesalCausa.where((causas_arel[:rol_interno].matches(query_string)).or(causas_arel[:rol_unico].matches(query_string)).or(causas_arel[:identificacion_causa].matches(query_string)).or(causas_arel[:tribunal].matches(query_string)))
			r_pro = causas.map { |a| a.general_causa }

		end

		if corte
			causas_arel      = CorteCausa.arel_table
			causas = CorteCausa.where((causas_arel[:numero_ingreso].matches(query_string)).or(causas_arel[:caratulado].matches(query_string)).or(causas_arel[:corte].matches(query_string)))
			r_cor = causas.map { |a| a.general_causa }

		end
		if suprema
			causas_arel      = SupremaCausa.arel_table
			causas = SupremaCausa.where((causas_arel[:numero_ingreso].matches(query_string)).or(causas_arel[:caratulado].matches(query_string)).or(causas_arel[:corte].matches(query_string)))
			r_sup = causas.map { |a| a.general_causa }

		end

	[r_lab,r_civ,r_pro,r_cor,r_sup].compact.reduce([], :|)
	end

end
