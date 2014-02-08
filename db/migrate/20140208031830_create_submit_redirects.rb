class CreateSubmitRedirects < ActiveRecord::Migration
  def change
    create_table :submit_redirects do |t|
      t.integer :form_id
      t.string :message
      t.string :phone
      t.string :address
      
      t.timestamps
    end
  end
end
