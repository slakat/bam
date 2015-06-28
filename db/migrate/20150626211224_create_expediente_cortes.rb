class CreateExpedienteCortes < ActiveRecord::Migration
  def change
    create_table :expediente_cortes do |t|
      t.string :corte
      t.string :libro
      t.string :rol_ing
      t.string :recurso
      t.integer :suprema_causa_id

      t.timestamps null: false
    end
  end
end
