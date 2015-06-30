class SearchRecords < ActiveRecord::Migration
  def change
    create_table :search_records do |t|
      t.string :query
      t.string :competencias
      t.string :user
      t.timestamps null: false
    end
  end
end
