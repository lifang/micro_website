class AddconmlnReminds < ActiveRecord::Migration
  def change
    add_column :reminds ,:days ,:integer
  end
end
