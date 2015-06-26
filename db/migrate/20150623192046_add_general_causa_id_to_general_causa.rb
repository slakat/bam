class AddGeneralCausaIdToGeneralCausa < ActiveRecord::Migration
  def change
    add_column :general_causas, :general_causa_id, :integer
  end
end
