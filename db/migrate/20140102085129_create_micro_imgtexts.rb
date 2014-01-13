class CreateMicroImgtexts < ActiveRecord::Migration
  def change
    create_table :micro_imgtexts do |t|
      t.string :title
      t.string :img_path
      t.text :content
      t.string :url
      t.integer :micro_message_id

      t.timestamps
    end
  end
end
