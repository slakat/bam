class AddLinksToCausas < ActiveRecord::Migration
  def change
  	add_column :civil_causas, :link, :string
  	add_column :corte_causas, :link, :string
  	add_column :laboral_causas, :link, :string
  	add_column :procesal_causas, :link, :string
  	add_column :suprema_causas, :link, :string
  end
end
