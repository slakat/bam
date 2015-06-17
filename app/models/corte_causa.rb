class CorteCausa < ActiveRecord::Base
  #has_one :general_causa, as: :causa
  has_many		:general_causa_cortes
	has_many		:general_causa, through: :general_causa_cortes

  validates_uniqueness_of :numero_ingreso, :scope => :fecha_ingreso

  def identificator
  	self.numero_ingreso
  end
end
