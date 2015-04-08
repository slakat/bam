class CreateUserCauses < ActiveRecord::Migration
  def change
    create_table :user_causes do |t|
      t.integer :cause_id
      t.integer :account_id

      t.timestamps
    end
  end
end
