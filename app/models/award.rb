class Award < ActiveRecord::Base
  attr_accessible :begin_date, :end_date, :name, :no_operation_number, :total_number
  belongs_to :site
  has_many :award_infos, dependent: :destroy
end
