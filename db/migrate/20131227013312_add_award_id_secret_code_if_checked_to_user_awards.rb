class AddAwardIdSecretCodeIfCheckedToUserAwards < ActiveRecord::Migration
  def change
    add_column :user_awards, :award_id, :integer
    add_column :user_awards, :secret_code, :string
    add_column :user_awards, :if_checked, :boolean
    change_column :user_awards, :open_id, :string
  end
end
