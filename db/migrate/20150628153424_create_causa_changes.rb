class CreateCausaChanges < ActiveRecord::Migration
  def change
    create_table :causa_changes do |t|
      t.date :fecha
      t.string :old_value
      t.string :new_value
      t.string :attribute
      t.string :identificador
      t.string :tipo

      t.timestamps null: false
    end
  end
end
