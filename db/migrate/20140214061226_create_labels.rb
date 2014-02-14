class CreateLabels < ActiveRecord::Migration
  def change
    create_table :labels do |t|
      t.integer :site_id
      t.integer :tag_id
      t.integer :client_id

      t.timestamps
    end
  end
end
