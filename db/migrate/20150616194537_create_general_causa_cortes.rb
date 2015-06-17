class CreateGeneralCausaCortes < ActiveRecord::Migration
  def change
    create_table :general_causa_cortes do |t|
      t.integer :general_causa_id
      t.integer :corte_id

      t.timestamps null: false
    end
  end
end
