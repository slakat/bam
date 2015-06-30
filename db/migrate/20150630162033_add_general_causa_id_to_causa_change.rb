class AddGeneralCausaIdToCausaChange < ActiveRecord::Migration
  def change
    add_column :causa_changes, :general_causa_id, :integer
  end
end
