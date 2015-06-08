class SupremaCausa < ActiveRecord::Base
  has_one :general_causa, as: :causa

  validates_uniqueness_of :numero_ingreso, :scope => :tipo_recurso

  def identificator
  	self.numero_ingreso
  end
end
