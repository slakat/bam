class CreateUserCauses < ActiveRecord::Migration
  def change
    create_table :user_causas do |t|
      t.integer :general_causa_id
      t.integer :account_id

      t.timestamps
    end
  end
end
