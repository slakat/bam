class CreateCausas < ActiveRecord::Migration
  def change
    create_table :civil_causas do |t|
      t.string 	:rol
      t.date 		:fecha_ingreso
      t.string 	:caratulado
      t.string 	:tribunal
      t.string 	:estado_procesal
      t.string 	:administrativo
			t.string 	:ubicacion

      t.timestamps
    end
  end
end
