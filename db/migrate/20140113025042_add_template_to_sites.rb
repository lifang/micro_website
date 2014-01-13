class AddTemplateToSites < ActiveRecord::Migration
  def change
    add_column :sites, :template, :integer, :default => 1  #给站点（首页）可选择模板
  end
end
