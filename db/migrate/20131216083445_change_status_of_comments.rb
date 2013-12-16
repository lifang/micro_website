class ChangeStatusOfComments < ActiveRecord::Migration
  def change
    change_column :replies, :status, :integer, :limit => 1, :default => 1
  end
end
