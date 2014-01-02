class CreateKeywords < ActiveRecord::Migration
  def change
    create_table :keywords do |t|
      t.integer :site_id
      t.string :keyword
      t.string :micro_message_id

      t.timestamps
    end
  end
end
