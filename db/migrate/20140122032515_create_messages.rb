class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.integer :site_id
      t.integer :from_user
      t.integer :to_user
      t.integer :types
      t.text :content
      t.boolean :status

      t.timestamps
    end
  end
end
