class AddLinksToCausas < ActiveRecord::Migration
  def change
  	add_column :civil_causas, :link, :string
  end
end
