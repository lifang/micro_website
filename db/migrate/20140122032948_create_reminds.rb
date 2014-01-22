class CreateReminds < ActiveRecord::Migration
  def change
    create_table :reminds do |t|
      t.integer :site_id
      t.string :content
      t.date :reseve_time
      t.string :title
      t.boolean :range

      t.timestamps
    end
  end
end
