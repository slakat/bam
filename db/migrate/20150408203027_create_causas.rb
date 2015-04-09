class CreateCausas < ActiveRecord::Migration
  def change
    create_table :civil_causas do |t|
      t.string 	:rol
      t.date 	:date
      t.string 	:caratulado
      t.string 	:tribunal

      t.timestamps
    end
  end
end
