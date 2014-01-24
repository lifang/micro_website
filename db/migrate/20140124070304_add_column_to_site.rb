class AddColumnToSite < ActiveRecord::Migration
  def change
    add_column :sites , :exist_app ,:boolean ,:default=>false
  end
end
