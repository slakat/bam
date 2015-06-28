class CreateExpedientes < ActiveRecord::Migration
  def change
    create_table :expedientes do |t|
      t.string :rol_rit
      t.string :ruc
      t.string :fecha
      t.string :caratulado
      t.string :tribunal
      t.integer :corte_causa_id
      t.integer :suprema_causa_id

      t.timestamps null: false
    end
  end
end
