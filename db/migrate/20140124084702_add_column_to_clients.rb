class AddColumnToClients < ActiveRecord::Migration
  def change
    add_column :clients ,:open_id , :string
  end
end
