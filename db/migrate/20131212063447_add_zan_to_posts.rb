class AddZanToPosts < ActiveRecord::Migration
  def change
     add_column :posts, :praise_number, :integer ,defalut:0
     add_column :posts,:comments_count,:integer,default:0
     
  end
end
