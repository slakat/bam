class CreateAccounts < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
      t.string :name
      t.string :lastname
      t.string :rut

      t.timestamps
    end
  end
end
