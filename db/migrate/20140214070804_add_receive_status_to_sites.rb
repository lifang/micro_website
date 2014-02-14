class AddReceiveStatusToSites < ActiveRecord::Migration
  def change
    add_column :sites, :receive_status, :boolean, :default => false
  end
end
