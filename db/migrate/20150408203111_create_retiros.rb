class CreateRetiros < ActiveRecord::Migration
  def change
    create_table :retiros do |t|
      t.string :cuaderno
      t.string :data_retiro
      t.string :status

      t.timestamps
    end
  end
end
