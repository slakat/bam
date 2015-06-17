class CivilCausa < ActiveRecord::Base
  has_one 		:general_causa, as: :causa
  has_many		:retiros

  validates_uniqueness_of :rol, :scope => :caratulado

  def identificator
  	self.rol
  end
end
