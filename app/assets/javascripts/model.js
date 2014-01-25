
function submit_model_page(site_id){
    var models=$(".main_cont").find(".main_tab");
    for(var i=0;i<models.length;i++){
        if($(models[i]).css("display")!="none"){
            if(i==0){
                submit_template1_2(models[i],1);
            }else if(i==1){
                submit_template1_2(models[i],2);
            }else if(i==2){ //模板3
                template3_Submit(site_id)
            }else if(i==3){
                
        }

            
        }
    }
}
function submit_template1_2(models,template){
    var bigimg =$(models).children(".homeBg").find("div").find("img");
    bigimg = $(bigimg).attr("src");
    if(bigimg==null){
        tishi_alert('请加入背景图片！');
        return false;
    }
    var imgarr = $(models).children(".homeMenu").find("li").find("img");
    if(template==1&&imgarr.length!=3){
        tishi_alert('存在未填充区域！');
        return false;
    }
    if(template==2&&imgarr.length!=8){
        tishi_alert('存在未填充区域！');
        return false;
    }
    var alinkarr = $(models).children(".homeMenu").find("input");
    var imgstr ="",alinkstr ="";
    for(var i=0;i<imgarr.length;i++){
        imgstr+=$(imgarr[i]).attr("src")+"|||";
        alinkstr += $(alinkarr[i]).attr("data-href")+"|||"
    }
    var html_content = $(models).html();
    html_content = html_content.replace(/;/g, "||");
    $.ajax({
        async:true,
        type : 'post',
        url:'/model_page',
        dataType:"json",
        data  :"site_id="+$("#site_id").val()+"&template="+template+"&bigimg="+bigimg+"&imgstr="+imgstr
        +"&alinkstr="+alinkstr +"&html_content="+html_content,
        success:function(data){
            if(data==1){
                tishi_alert("保存成功!");
            }
        }
    });
}


function template3_Submit(site_id){
    var flag = true;
    $(".tmp_280-196 li, .temp75-70 li, .temp106-80 li").each(function(){
        if($(this).find("input.img_src").val() == ""){
            tishi_alert("有区域未填充");
            flag = false;
            return false;
        }
    });

    if(flag){
        var form = $(".iv_temp3").parent("form")
        var dataValue = form.serialize();
        var content = $(".iv_temp3").html();
        content = content.replace(/;/g, "||");  //把分号替换掉，否则表单提交不完全，会被分号隔开
        dataValue = dataValue + "&page[content]=" + content;

        $.ajax({
            url: "/sites/" + site_id + "/pages/save_template3",
            type: "POST",
            dataType: "text",
            data: dataValue,
            success:function(data){
                tishi_alert("保存成功")
            },
            error:function(data){
            // alert("error");
            }
        })
    }
    
}

function add_sub_template(){
    var l=$(".smlPicList.cf").find("div").length;
    $(".smlPicList.cf").append(" <div class='smlPic'><a class='scd_btn' name='addLink'><span>"+(l+1)+"</span></a><input type='hidden' class='img_lin' name='img_src[]'  /><input type='hidden' class='img_link' name='img_link[]' value='#'/><span class='close' onclick='remove_template(this)'></span></div>");
    $input = $( ".smlPic a" );
    it_drop($input);
}

function remove_template(value){
    $(value).parent().remove();
}
function submit_sub_page(){
    var title =$.trim($("#title").val());
    var name =$.trim($("#name").val());
    var models=$(".main_cont").find(".m_tab");
    if(title==""){
        tishi_alert('请输入标题');
        return false;
    }
    if(name ==""){
        tishi_alert('请输入文件名');
        return false;
    }

    
    
    for(var i=0;i<models.length;i++){
        if($(models[i]).css("display")!="none"){
            $("#sub_title1").val(title);
            $("#sub_name1").val(name);
            $("#sub_m_title").val(title);
            $("#sub_m_name").val(name);
            if(i==0){
                if($(".smlPic").find("a").length!=$(".smlPic").find("img").length ||$(".smlPic").find("a").length==0 ){
                    tishi_alert('存在未填充区域或者无图片区域！');
                    return false;
                }
                $("#html_content").val($(".iphoneVirtual form").html());
                $(".iphoneVirtual form").submit();
            }else if(i==1){
                if($.trim($("#zdy_sub_content").val())==""){
                    tishi_alert('请输入内容！');
                    return false;
                }
                $(".iv_temp4.main_tab.m_tab form").submit();
            }
        }
    }
     
}
function show_sub(){
    $(".iphoneVirtual").hide();
    $("#tupian").hide();
    $(".iv_temp4").show();
}