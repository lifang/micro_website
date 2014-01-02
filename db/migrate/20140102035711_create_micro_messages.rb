class CreateMicroMessages < ActiveRecord::Migration
  def change
    create_table :micro_messages do |t|
      t.integer :site_id
      t.integer :mtype

      t.timestamps
    end
  end
end
