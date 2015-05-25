class LaboralCausa < ActiveRecord::Base
  has_one :general_causa, as: :causa

  def as_json(options={})
    { :id => self.general_causa.id,
      :real_id => self.id,
      :rit => self.rit,
      :ruc => self.ruc,
      :caratulado => self.caratulado
    }

  end
end
