class CorteCausa < ActiveRecord::Base
  has_one :general_causa, as: :causa

  validates_uniqueness_of :numero_ingreso, :scope => :fecha_ingreso

  def identificator
  	self.numero_ingreso
  end
end
