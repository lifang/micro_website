class CreateAwardInfos < ActiveRecord::Migration
  def change
    create_table :award_infos do |t|
      t.integer :award_id
      t.string :name
      t.string :content
      t.integer :number

      t.timestamps
    end
  end
end
