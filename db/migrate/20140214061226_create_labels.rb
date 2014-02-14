class CreateLabels < ActiveRecord::Migration
  def change
    create_table :labels do |t|
      t.integer :site_id
      t.integer :tag_id
      t.integer :client_id

      t.timestamps
    end
    add_index :labels,:site_id
    add_index :labels,:tag_id
    add_index :labels,:client_id
  end
end
