class RenameColumn < ActiveRecord::Migration
  def change
  	rename_column :causa_changes, :attribute, :atributo
  end
end
