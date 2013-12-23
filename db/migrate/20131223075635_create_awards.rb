class CreateAwards < ActiveRecord::Migration
  def change
    create_table :awards do |t|
      t.integer :site_id
      t.string :name
      t.date :begin_date
      t.date :end_date
      t.integer :total_number
      t.integer :no_operation_number

      t.timestamps
    end
  end
end
