module ResoursesHelper
  def which_res(name)
    @img_resources=%w[jpg png gif]
    @voice_resources=%w[mp3]
    @video_resoures=%w[mp4 avi rm rmvb]
    name=name.split('.')[-1]
    if @img_resources.include?(name)
      return 'img'
    elsif @voice_resources.include?(name)
      return 'voice'
    else @video_resoures.include?(name)
      return 'voide'
    end
  end
end
