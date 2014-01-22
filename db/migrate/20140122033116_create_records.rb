class CreateRecords < ActiveRecord::Migration
  def change
    create_table :records do |t|
      t.integer :site_id
      t.text :content
      t.string :title

      t.timestamps
    end
  end
end
