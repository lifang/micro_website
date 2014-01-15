function submit_model_page(){
   
    var models=$(".main_cont").find(".main_tab");
    for(var i=0;i<models.length;i++){
        if($(models[i]).css("display")!="none"){
            if(i==0){
                var bigimg =$(models[i]).children(".homeBg").find("div").find("img");
                bigimg = $(bigimg).attr("src");
                var imgarr = $(models[i]).children(".homeMenu").find("li").find("img");
                var imgstr="";
                for(var i=0;i<imgarr.length;i++){
                    imgstr+=$(imgarr[i]).attr("src")+","
                }
                var html_content = $(models[i]).html();
                alert(bigimg+imgstr);
                
                $.ajax({
                    async:true,
                    type : 'post',
                    url:'/model_page',
                    dataType:"json",
                    data  :"site_id="+$("#site_id").val()+"&template=1&bigimg="+bigimg+"&imgstr="+imgstr+"&html_content="+html_content,
                    success:function(data){
                        if(data==1){
                            tishi_alert("success!");
                        }
                    }
                });
            }else if(i==1){

            }else if(i==2){

            }else if(i==3){
                
        }
            
            
            
        }
    }
}