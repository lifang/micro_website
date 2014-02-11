class AddSolidLinkFlagToMicroMessages < ActiveRecord::Migration
  def change
    add_column :micro_messages, :solid_link_flag, :integer  #消息回复 0 是刮刮乐  1是 app
  end
end
