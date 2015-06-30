class ProcesalCausa < ActiveRecord::Base
  has_one :general_causa, as: :causa

  validates_uniqueness_of :rol_interno, :scope => :rol_unico

  def identificator
  	self.rol_unico
  end

  def caratulado
    self.identificacion_causa
  end
end
