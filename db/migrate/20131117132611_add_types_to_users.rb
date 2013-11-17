class AddTypesToUsers < ActiveRecord::Migration
  def change
    change_column :users, :admin, :integer, :limit => 1
    rename_column :users, :admin, :types

  end
end
