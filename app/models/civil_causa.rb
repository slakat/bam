class CivilCausa < ActiveRecord::Base
  has_one :general_causa, as: :causa
end
