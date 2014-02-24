/* 
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
$(function(){
    /*design*/
    $(".second_box .close, .second_box .cancel").click(function(){
        $(this).parents(".second_box").hide();
        $(".second_bg").hide();
    });

    $(".second_content .tab").on("click",function(){
        if(!$(this).hasClass("curr")){
            $(".second_content .tab").removeClass("curr");
            $(".tabDiv").removeClass("curr");
            $(this).addClass("curr");
            var i = $(".tab").index(this);
            $(".tabDiv").eq(i).addClass("curr");
        }
    });

    $.each($(".category li a"),function(i,item){
        if(i%2 != 0){
            $(item).css("background","#53656c");
        }
    });
    $.each($(".nav_d li a"),function(i,item){
        if(i%2 != 0){
            $(item).css("background","#53656c");
        }
    });

    $(".leftSide").css("height",$(document).height() - 60 +"px");
    /**/
    $(".ad_num").on("click","li",function(){
        if(!$(this).hasClass("curr")){
            $(".ad_num li").removeClass("curr");
            $(this).addClass("curr");
            var i = $(".ad_num li").index(this);
            $(".ad_box ul").css("left",-i*280+"px");
        }
    });

    $(".iphoneVirtual").on("click",".opt.rad",function(){
        if($(this).hasClass("check")){
            $(this).removeClass("check");
        }else{
            $(this).parent().find(".rad").removeClass("check");
            $(this).addClass("check");
        }
    });
    $(".iphoneVirtual").on("click",".opt.chk",function(){
        if($(this).hasClass("check")){
            $(this).removeClass("check");
        }else{
            $(this).addClass("check");
        }
    });


    $(".insetBox").on("click",".optBox .close2",function(){
        $(this).parents(".optBox").remove();
    });

    $(".addItem").on("click",".addOptBox",function(){
        var item = $(this).parents(".addItem");
        if($(item).hasClass("addRdoItem")){
            $(item).find(".insetBox").append('<div class="optBox"><label>单选框选项： &nbsp;</label><input type="text" /><span class="close2"></span></div>');
        }else if($(item).hasClass("addChekItem")){
            $(item).find(".insetBox").append('<div class="optBox"><label>复选框选项： &nbsp;</label><input type="text" /><span class="close2"></span></div>');
        }else if($(item).hasClass("addSelItem")){
            $(item).find(".insetBox").append('<div class="optBox"><label>下拉框选项： &nbsp;</label><input type="text" /><span class="close2"></span></div>');
        }
        else if($(item).hasClass("addLabelItem")){
            $(item).find(".insetBox").append('<div class="optBox"><label>标签框选项：&nbsp;</label><input type="text" /><span class="close2"></span></div>');
        }
    });

    // 定义图片库, drop area
    var $gallery = $( ".picRes" );
    // 使图片库里面的元素可托拽
    it_drag($( ".picBox", $gallery ));

    //初始化滑动块宽度
    var i = $(".ad_box li").length;
    $(".ad_box ul").css("width",Number(i+1)*280+"px");

    $(".homeAd .addAdPic").on("click",function(){
        var i = $(".ad_box li").length;
        $(".ad_box ul").append("<li><a class='scd_btn'>"+ Number(i+1)+"</a><input type='hidden' class='img_src' name='ad_src[]'/><span class='close'></span></li>");
        $(".ad_box ul").css("width",Number(i+1)*280+"px");
        $(".ad_num ul").append("<li>"+ Number(i+1)+"</li>");
        $input_280 = $( ".tmp_280-196 a" );
        temp_it_drop_slide($input_280, 280, 196);
        $(".homeAd li span.close").on("click",function(){
            li = $(this).parent("li");
            var index = $(".ad_box li").index(li);
            $($(".ad_num li")[index]).remove();
            li.remove();
            $(".ad_box li a").each(function(index){
                if($.trim($(this).text()) != ""){
                    $(this).text(index + 1);
                }
            })
        });
    });

    $(".homeAd li span.close").on("click",function(){
        li = $(this).parent("li");
        var index = $(".ad_box li").index(li);
        $($(".ad_num li")[index]).remove();
        li.remove();
        $(".ad_box li a").each(function(index){
            if($.trim($(this).text()) != ""){
                $(this).text(index + 1);
            }
        })
    });

    //切换模板
    $(".tmp_list li").on("click",function(){
        var className = $(this).attr("class").split(/\s/)[0];
        $(".tmp_list li").removeClass("hover");
        $(".main_cont .main_tab").hide();
        $(".main_cont .iv_" + className).show();
        if(className == "temp4"){
            $(".main_cont .picChoice").hide();
            $(".main_cont .pageAct").hide();
            $(".iv_temp4 .pageAct").show();
        }else{
            $(".main_cont .picChoice").show();
            $(".main_cont .pageAct").show();
        }

        $(this).addClass("hover");
    })

    //加超链接
    $(".temp3Block li").on("click",function(){
        var spec_className = $(this).parent("ul").attr("class").split(/\s/)[0];
        var index = $("." + spec_className + " li").index($(this));
        show_tag($("#linkPage"));

        $("#linkPage .cancel").click(function(){
            hide_tab($("#linkPage"));
        });
        $("#linkPage").find(".hiddenIndex").val(index);
        $("#linkPage").find(".hiddenBlock").val(spec_className);
    });
    //加超链接
    $(".homeMenu a").on("click",function(){
        var spec_className = $(this).parent("ul").attr("class").split(/\s/)[0];
      
        var index = $("." + spec_className + " a").index($(this));
        
        showLinkTab()

        $("#linkPage").find(".hiddenIndex").val(index);
        $("#linkPage").find(".hiddenBlock").val(spec_className);
    });
    
    $(".smlPic a").on("click",function(){
        
        var spec_className = $(this).parent("div").parent("div").attr("class").split(/\s/)[0];

        var index = $("." + spec_className + " div a").index($(this));
        showLinkTab()

        $("#linkPage").find(".hiddenIndex").val(index);
        $("#linkPage").find(".hiddenBlock").val(spec_className);
    });

    $(".iphvAct").on("click", "button", function(){
        //showLinkTab();
        })


});

function showLinkTab(){
    show_tag($("#linkPage"));

    $("#linkPage .cancel").click(function(){
        hide_tab($("#linkPage"));
    });
}


function setLink(from){
    var link = "";
    link = findLink(link);
    if(link != ""){
    	 
        if(from == "main_page"){
            var spec_className = $("#linkPage").find(".hiddenBlock").val();
            var index = $("#linkPage").find(".hiddenIndex").val();
            if(spec_className=='homeMenu1' || spec_className=='homeMenu2'){
                $($("." + spec_className).find(".img_link")[index]).attr("value", link);
            }else if(spec_className=="smlPicList"){
                $($("." + spec_className + " div .img_link")[index]).attr("value", link);
            }else{
                $($("." + spec_className + " li")[index]).find("input.img_link").val(link);
            }
            hide_tab($("#linkPage"));
        }else if(from == "form"){
            $(".hidden_redirect_path").val(link);
            hide_tab($("#linkPage"));
        }else if(from == "sub_page"){
        	var spec_className = $("#linkPage").find(".hiddenBlock").val();
        	
            var index = $("#linkPage").find(".hiddenIndex").val();
            if(spec_className=='smlPicList'){
                $($("." + spec_className).find(".img_link")[index]).attr("value", link);
            }
            hide_tab($("#linkPage"));
        }

    }else{
        tishi_alert("未选择链接！");
    }
}


function findLink(link){
    $(".addLink .tabs").find("span").each(function(){
        if($(this).hasClass("curr")){
            if($(this).text() == "站内链接"){
    	       
                var checked = $(".addLink input[name=insite_link]:checked");
                link = checked.length > 0 ? checked.val() : "";
            }else{
                link = $(".addLink input[name=outside_link]").val()
            }
        }
    });
    return link;
}