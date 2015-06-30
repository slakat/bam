class SupremaCausa < ActiveRecord::Base
  has_one 			:general_causa, as: :causa
 	# has_many		:general_causa_suprema
	# has_many		:general_causa, through: :general_causa_suprema
	has_one 		:expediente
	has_one 		:expediente_corte

  validates_uniqueness_of :numero_ingreso, :scope => :tipo_recurso

  def identificator
  	self.numero_ingreso
  end

  def tribunal
    self.corte
  end

  def get_expediente
    
    causa = CivilCausa.where(rol: self.expediente.rol_rit, tribunal: self.expediente.tribunal)
    if causa.nil?
      causa = LaboralCausa.where(rit: self.expediente.rol_rit, tribunal: self.expediente.tribunal)
    end
    if causa.nil?
      causa = ProcesalCausa.where(rol_interno: self.expediente.rol_rit, tribunal: self.expediente.tribunal)
    end
    if causa.nil?
      causa = ProcesalCausa.where(rol_unico: self.expediente.rol_rit, tribunal: self.expediente.tribunal)
    end
    unless causa.nil?
      causa.first
    else
      nil
    end

  end

  def get_expediente_corte
    
    causa = CorteCausa.where(libro: self.expediente_corte.libro, numero_ingreso: self.expediente_corte.rol_ing)
    
    unless causa.nil?
      causa.first
    else
      nil
    end

  end

end
