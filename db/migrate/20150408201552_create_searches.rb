class CreateSearches < ActiveRecord::Migration
  def change
    create_table :searches do |t|
      t.string 		:term
      t.integer 	:account_id
      t.timestamps
    end
  end
end
