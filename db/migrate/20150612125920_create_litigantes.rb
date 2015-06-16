class CreateLitigantes < ActiveRecord::Migration
  def change
    create_table :litigantes do |t|
      t.string :nombre
      t.string :rut
      t.string :persona
      t.string :participante
      t.integer :general_causa_id

      t.timestamps null: false
    end
  end
end
