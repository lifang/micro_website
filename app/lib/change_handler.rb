module ChangeHandler
  def change_stat
    site=Site.find(self.site_id)
    site.update_attribute(:status,Site::STATUS_VALUE[1])
  end
end