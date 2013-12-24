class AwardInfo < ActiveRecord::Base
  attr_accessible :award_id, :content, :name, :number
  belongs_to :award
end
