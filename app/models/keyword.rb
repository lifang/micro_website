class Keyword < ActiveRecord::Base
  belongs_to :site
  belongs_to  :micro_message
  attr_accessible :keyword, :micro_message_id, :site_id

  TYPE = {:auto => 0, :keyword => 1}  #types: 0 => 自动回复, 1 =>关键词回复
end
