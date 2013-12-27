class UserAward < ActiveRecord::Base
  attr_accessible :award_info_id, :open_id
  belongs_to :award_info
end
