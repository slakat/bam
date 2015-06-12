class CreateLitigantes < ActiveRecord::Migration
  def change
    create_table :litigantes do |t|
      t.string :name
      t.integer :general_causa_id

      t.timestamps null: false
    end
  end
end
