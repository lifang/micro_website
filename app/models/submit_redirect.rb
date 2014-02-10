class SubmitRedirect < ActiveRecord::Base
  attr_accessible :message, :phone, :address, :form_id
  belongs_to :page, :foreign_key => "form_id"
end
