class AddZanToPosts < ActiveRecord::Migration
  def change
     add_column :posts, :praise_number, :integer
  end
end
