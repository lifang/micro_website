#encoding: utf-8
class ResourcesController < ApplicationController
  def upload
    if request.get?
      flash[:error]="error"
      render action: 'index'
    else
       uploaded_file = params['file']['filedata']
       puts 'dscfdasdas----->>>>',uploaded_file
       if_succ,filepath = upload_file(uploaded_file,['jpg','txt'],'D:/a')
       flash[:success]='success'
       redirect_to resources_path
    end
  end
  
  def upload_file(file,extname,target_dir)
    if file.nil? || file.original_filename.empty?
      return false,"空文件或者文件名错误"
    else
      timenow = Time.now
      filename = file.original_filename  #file的名字
      fileloadname = timenow.strftime("%d%H%M%S")+filename #保存在文件夹下面的上传文件的名称

      if extname.include?(File.extname(filename).downcase)
        #创建目录
        #首先获得当前项目所在的目录+文件夹所在的目录
        path = Rails.root.join(target_dir,timenow.year.to_s,timenow.month.to_s)
        #生成目录
        FileUtils.makedirs(path)
        File.open(File.join(path,fileloadname),"wb") do |f|
          f.write(file.read)
          return true,File.join(timenow.year.to_s,timenow.month.to_s,fileloadname)
        end
      else
        return false,"必须是#{extname}类型的文件"
      end
    end
  end
end