class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :phone
      t.string :email,              :null => false, :default => ""
      t.string :encrypted_password, :null => false, :default => ""
      t.boolean :admin #if is admin

      ## Recoverable
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at

      t.timestamps
    end

    add_index :users, :name
    add_index :users, :phone
    add_index :users, :email,                :unique => true
    add_index :users, :reset_password_token, :unique => true
  end
end
