class CreateClients < ActiveRecord::Migration
  def change
    create_table :clients do |t|
      t.string :name
      t.integer :mobiephone
      t.integer :site_id
      t.text :html_content
      t.integer :types
      t.string :password
      t.string :username
      t.string :avatar_url
      t.boolean :has_new_message
      t.boolean :has_new_record

      t.timestamps
    end
  end
end
