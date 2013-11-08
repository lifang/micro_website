class CreateSites < ActiveRecord::Migration
  def change
    create_table :sites do |t|
      t.string :name
      t.string :root_path
      t.string :notes
      t.integer :status, :limit => 1
      t.integer :user_id
      
      t.timestamps
    end

     add_index :sites, :root_path
     add_index :sites, :name
     add_index :sites, :status
     add_index :sites, :user_id
  end
end
