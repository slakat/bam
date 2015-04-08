class CreateClientCauses < ActiveRecord::Migration
  def change
    create_table :client_causes do |t|
      t.integer :cause_id
      t.integer :client_id

      t.timestamps
    end
  end
end
