class CreateResources < ActiveRecord::Migration
  def change
    create_table :resources do |t|
      t.string :path_name
      t.integer :site_id
      
      t.timestamps
    end

    add_index :resources, :path_name
    add_index :resources, :site_id
  end
end
