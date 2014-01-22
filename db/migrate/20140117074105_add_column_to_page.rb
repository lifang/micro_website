class AddColumnToPage < ActiveRecord::Migration
  def change
    add_column :pages,:template,:integer,:default=>0
  end
end
