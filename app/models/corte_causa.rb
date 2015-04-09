class CorteCausa < ActiveRecord::Base
  has_many :general_causas, as: :causa
end
