#encoding: utf-8
class CreatePages < ActiveRecord::Migration
  def change
    create_table :pages do |t|
      t.string :title
      t.string :file_name
      t.integer :types, :limit => 1
      t.integer :site_id
      t.string :path_name
      t.boolean :authenticate
      t.text :element_relation #表单元素对应关系
      
      t.timestamps
    end

    add_index :pages, :site_id
    add_index :pages, :types
    add_index :pages, :authenticate
  end
end
