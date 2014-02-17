class ChangeClientStatus < ActiveRecord::Migration
  def change
    change_column :clients, :status, :boolean, :default => false
  end
end
