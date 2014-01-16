class CreateMicroMessages < ActiveRecord::Migration
  def change
    create_table :micro_messages do |t|
      t.integer :site_id
      t.boolean :mtype  #图文/文字

      t.timestamps
    end
  end
end
