class ChangeTables < ActiveRecord::Migration
  def change
    add_column :clients,:status,:boolean
    add_column :messages , :message_type , :integer , :default =>0
    add_column :messages , :message_path , :string 
    add_column :sites , :not_receive_start_at , :datetime
    add_column :sites , :not_receive_end_at , :datetime
    add_index :clients,:status
  end
end
