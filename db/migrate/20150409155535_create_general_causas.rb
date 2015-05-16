class CreateGeneralCausas < ActiveRecord::Migration
  def change
    create_table :general_causas do |t|      
      t.integer :causa_id
      t.string :causa_type

      t.timestamps
    end
  end
end
