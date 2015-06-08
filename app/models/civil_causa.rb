class CivilCausa < ActiveRecord::Base
  has_one :general_causa, as: :causa

  validates_uniqueness_of :rol, :scope => :caratulado

  def identificator
  	self.rol
  end
end
