function submit_model_page(){
    var models=$(".main_cont").find(".main_tab");
    for(var i=0;i<models.length;i++){
        if($(models[i]).css("display")!="none"){
            if(i==0){
            // alert($(models[i]).html());
            }else if(i==1){

            }else if(i==2){ //模板3
                template3_Submit()
            }else if(i==3){
                
        }
            
        }
    }
}

function template3_Submit(){
    var slide_src = "";
    var middle_src = "";
    var bottom_src = "";
    var flag = true;
    $(".tmp_280-196 li, .temp75-70 li, .temp106-80 li").each(function(){
        if(typeof($(this).attr("data-src")) == "undefined" || $(this).attr("data-src") == ""){
            tishi_alert("有区域未填充");
            flag = false;
            return false;
        }else{
            if($(this).parent("ul").hasClass("tmp_280-196")){
                slide_src = slide_src + "," + $(this).attr("data-src");
            }else if($(this).parent("ul").hasClass("temp75-70")){
                middle_src = middle_src + "," + $(this).attr("data-src");
            }else{
                bottom_src = bottom_src + "," + $(this).attr("data-src");
            }
        }
    });

/*if(flag){
        $.ajax({
        url: $(obj).attr("data-url"),
        type: "POST",
        dataType: "html",
        success:function(data){
            $(".bbs_dropDown").remove();
            $(".bbs-a").last().after(data);
        },
        error:function(data){
            alert("error");
        }
    })
}*/
    
}