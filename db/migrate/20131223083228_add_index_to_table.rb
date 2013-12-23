class AddIndexToTable < ActiveRecord::Migration
  def change
    add_index :award_infos,:award_id
    add_index :awards,:site_id
    add_index :user_awards,:award_info_id
  end
end
