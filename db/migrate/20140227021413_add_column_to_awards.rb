class AddColumnToAwards < ActiveRecord::Migration
  def change
    add_column :awards , :types ,:integer,default:0
  end
end
