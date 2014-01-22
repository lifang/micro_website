class ChangeColumnToClients < ActiveRecord::Migration
  def up
    change_column :clients,:mobiephone ,:string
  end

  def down
  end
end
