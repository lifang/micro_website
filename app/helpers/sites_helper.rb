#encoding: utf-8
module SitesHelper
  
 def status_desc status #根据status字段获得站点状态描述
  
   case status
    when 0  then  '新建'
    when 1  then  '未审核'
    when 2  then  '待审核'
    when 3  then  '审核通过'
    when 4  then  '审核不通过'
   end  
 end
 def change_status(site_id,value)
   site=Site.find(site_id);
   site.update_attribute(:status,value)
 end
  
  
end