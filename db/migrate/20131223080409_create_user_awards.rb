class CreateUserAwards < ActiveRecord::Migration
  def change
    create_table :user_awards do |t|
      t.integer :award_info_id
      t.integer :open_id

      t.timestamps
    end
  end
end
