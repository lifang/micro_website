class AddStatusToUsers < ActiveRecord::Migration
  def change
    add_column :users, :status, :integer, :limit => 1
  end
end
