class AddImgToAwardInfos < ActiveRecord::Migration
  def change
    add_column :award_infos, :img, :string
    add_column :award_infos, :award_index, :integer
  end
end
