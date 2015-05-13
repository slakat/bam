class CreateClientCausas < ActiveRecord::Migration
  def change
    create_table :client_causas do |t|
      t.integer :general_causa_id
      t.integer :client_id

      t.timestamps
    end
  end
end
