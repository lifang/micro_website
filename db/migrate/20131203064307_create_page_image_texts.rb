class CreatePageImageTexts < ActiveRecord::Migration
  def change
    create_table :page_image_texts do |t|
      t.integer :page_id
      t.text :img_path
      t.text :content

    end
  end
end
