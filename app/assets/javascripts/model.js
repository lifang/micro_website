function submit_model_page(site_id){
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

            }else if(i==2){ //模板3
                template3_Submit()
            }else if(i==3){
                
        }

            
        }
    }
}

function submit_template(site_id, flag){
    if(flag == 3){
        template3_Submit(site_id)
    }
}

function template3_Submit(site_id){
    
    var flag = true;
    $(".tmp_280-196 li, .temp75-70 li, .temp106-80 li").each(function(){
        if(typeof($(this).attr("data-src")) == "undefined" || $(this).attr("data-src") == ""){
            tishi_alert("有区域未填充");
            flag = false;
            return false;
        }else{
            if($(this).parent("ul").hasClass("tmp_280-196")){
                slide_src = slide_src + "," + $(this).attr("data-src");
                slide_link = slide_link + "," + $(this).attr("data-href");
            }else if($(this).parent("ul").hasClass("temp75-70")){
                middle_src = middle_src + "," + $(this).attr("data-src");
                middle_link = middle_link + "," + $(this).attr("data-href");
            }else{
                bottom_src = bottom_src + "," + $(this).attr("data-src");
                bottom_link = bottom_link + "," + $(this).attr("data-href");
            }
        }
    });

if(flag){
    var src = slide_src
        var page_content = $(".iv_temp3").html()
        $.ajax({
        url: "/sites/" + site_id + "/pages/save_template3",
        type: "POST",
        dataType: "text",
        data: {slide_src : slide_src, middle_src:middle_src, bottom_src: bottom_src},
        success:function(data){
            alert(data)
        },
        error:function(data){
            alert("error");
        }
    })
}
    
}