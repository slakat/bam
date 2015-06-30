class SupremaCausa < ActiveRecord::Base
  has_one 			:general_causa, as: :causa
 	# has_many		:general_causa_suprema
	# has_many		:general_causa, through: :general_causa_suprema

  validates_uniqueness_of :numero_ingreso, :scope => :tipo_recurso

  def identificator
  	self.numero_ingreso
  end

  def tribunal
    self.corte
  end
end
