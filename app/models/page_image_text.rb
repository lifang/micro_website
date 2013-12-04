class PageImageText < ActiveRecord::Base
  attr_accessible :img_path, :content
  belongs_to :page
  serialize :img_path
  serialize :content
end
