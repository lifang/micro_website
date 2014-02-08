class AddMsgIdToMessages < ActiveRecord::Migration
  def change
    add_column :messages, :msg_id, :string
    add_index :messages, :msg_id
  end
end
