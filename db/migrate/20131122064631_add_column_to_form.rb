class AddColumnToForm < ActiveRecord::Migration
  def change
    add_column :pages , :img_path , :string
  end
end
