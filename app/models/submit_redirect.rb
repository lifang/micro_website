class SubmitRedirect < ActiveRecord::Base
  attr_accessible :message, :phone, :address, :form_id, :page_id
  belongs_to :page
end
