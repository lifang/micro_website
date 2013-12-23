class Award < ActiveRecord::Base
  attr_accessible :begin_date, :end_date, :name, :no_operation_number, :total_number
end
