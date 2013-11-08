#encoding: utf-8
class CreateFormData < ActiveRecord::Migration
  def change
    create_table :form_datas do |t|
      t.integer :page_id
      t.text :data_hash  #用户提交数据结果集
      t.integer :user_id

      t.timestamps
    end

     add_index :form_datas, :page_id
  end

end
