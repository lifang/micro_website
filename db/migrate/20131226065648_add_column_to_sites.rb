class AddColumnToSites < ActiveRecord::Migration
  def change
    add_column :sites,:cweb ,:string
  end
end
