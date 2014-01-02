class CreateKeywords < ActiveRecord::Migration
  def change
    create_table :keywords do |t|
      t.integer :site_id
      t.string :keyword
      t.integer :micro_message_id
      t.boolean :types
      t.timestamps
    end
  end
end
