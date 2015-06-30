class LaboralCausa < ActiveRecord::Base
  has_one :general_causa, as: :causa

  validates_uniqueness_of :rit, :scope => :ruc

  def as_json(options={})
    { :id => self.general_causa.id,
      :real_id => self.id,
      :rit => self.rit,
      :ruc => self.ruc,
      :caratulado => self.caratulado
    }

  end

  def identificator
    self.ruc
  end

end
