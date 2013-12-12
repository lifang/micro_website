class CreateReplies < ActiveRecord::Migration
  def change
    create_table :replies do |t|
      t.integer :post_id
      t.string :reply_content
      t.integer :send_open_id
      t.integer :target_open_id

      t.timestamps
    end
  end
end
