#encoding: utf-8
class CreateFormDatas < ActiveRecord::Migration
  def change
    create_table :form_datas do |t|
      t.integer :page_id
      t.text :data_hash  #表单数据
      t.integer :user_id

      t.timestamps
    end

     add_index :form_datas, :page_id
  end

end
