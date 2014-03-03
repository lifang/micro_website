class AddColumnToAwardInfo < ActiveRecord::Migration
  def change
    add_column :award_infos,:code,:text
  end
end
