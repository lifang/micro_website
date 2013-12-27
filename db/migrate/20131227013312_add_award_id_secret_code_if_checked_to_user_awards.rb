class AddAwardIdSecretCodeIfCheckedToUserAwards < ActiveRecord::Migration
  def change
    add_column :user_awards, :award_id, :integer
    add_column :user_awards, :secret_code, :string
    add_column :user_awards, :if_checked, :boolean
  end
end
