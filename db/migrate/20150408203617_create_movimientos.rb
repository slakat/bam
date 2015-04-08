class CreateMovimientos < ActiveRecord::Migration
  def change
    create_table :movimientos do |t|
      t.string :dato1
      t.string :dato2

      t.timestamps
    end
  end
end
