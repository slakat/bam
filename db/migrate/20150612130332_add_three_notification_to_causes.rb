class AddThreeNotificationToCauses < ActiveRecord::Migration
  def change
  	add_column :user_causas, :not1, :integer, default: 1
  	add_column :user_causas, :not2, :integer, default: 1
  	add_column :user_causas, :not3, :integer, default: 1
  end
end
