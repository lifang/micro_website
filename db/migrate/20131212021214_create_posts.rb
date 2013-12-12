class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.string :post_content
      t.integer :post_status
      t.integer :site_id

      t.timestamps
    end
  end
end
