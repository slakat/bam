class CreateUserCauses < ActiveRecord::Migration
  def change
    create_table :user_causas do |t|
      t.integer :causa_id
      t.integer :account_id

      t.timestamps
    end
  end
end
