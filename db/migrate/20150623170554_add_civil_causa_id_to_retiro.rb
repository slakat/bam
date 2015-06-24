class AddCivilCausaIdToRetiro < ActiveRecord::Migration
  def change
    add_column :retiros, :civil_causa_id, :integer
  end
end
