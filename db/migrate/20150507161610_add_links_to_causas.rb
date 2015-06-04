class AddLinksToCausas < ActiveRecord::Migration
  def change
  	add_column :civil_causas, :link, :text
  	add_column :corte_causas, :link, :text
  	add_column :laboral_causas, :link, :text
  	add_column :procesal_causas, :link, :text
  	add_column :suprema_causas, :link, :text
  end
end
