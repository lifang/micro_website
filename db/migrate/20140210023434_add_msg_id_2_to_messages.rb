class AddMsgId2ToMessages < ActiveRecord::Migration
  def change
    remove_column :messages, :msg_id
    add_column :messages, :msg_id, :string
    add_index :messages, :msg_id, :unique => true, :name => 'by_msg_id'
  end
end
