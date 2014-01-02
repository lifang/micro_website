class CreateMicroMessages < ActiveRecord::Migration
  def change
    create_table :micro_messages do |t|
      t.integer :site_id
      t.string :title
      t.string :img_path
      t.string :content
      t.string :url
      t.integer :mtype

      t.timestamps
    end
  end
end
