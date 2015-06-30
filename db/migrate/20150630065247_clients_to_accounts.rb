class ClientsToAccounts < ActiveRecord::Migration
  def change
    add_column :clients, :account_id, :integer, index:true
  end
end
