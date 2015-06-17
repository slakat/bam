class CreateGeneralCausaSupremas < ActiveRecord::Migration
  def change
    create_table :general_causa_supremas do |t|
      t.integer :general_causa_id
      t.integer :suprema_id

      t.timestamps null: false
    end
  end
end
