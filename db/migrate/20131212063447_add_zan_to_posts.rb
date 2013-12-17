class AddZanToPosts < ActiveRecord::Migration
  def change
<<<<<<< Updated upstream
     add_column :posts, :praise_number, :integer ,default:0
     add_column :posts,:comments_count,:integer,default:0
=======
     add_column :posts, :praise_number, :integer , defalut:0
     add_column :posts,:comments_count,:integer, default:0
>>>>>>> Stashed changes
     
  end
end
