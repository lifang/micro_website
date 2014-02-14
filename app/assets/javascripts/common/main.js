$(function() {

    $(".third_box .close").click(function(){
        $(this).parents(".third_box").hide();
        $(".third_bg").hide();
    });

    $("body").on("click",".thd_btn",function(){
        $(".third_bg").show();
        $(".third_box."+$(this).attr("name")).attr("to",$(this).parents(".second_box").attr("class"));
        $(".third_box."+$(this).attr("name")).show();
    });

    var insert1 = "<div class='insertBox'><span class='delete'></span><div class='inputArea'>双击输入标题</div><input class='txtArea' type='text' /></div>";

    var insert2 = "<div class='insertBox'><span class='delete'></span><div class='inputArea'>双击输入问题</div><input class='txtArea' type='text' /><div><input type='radio' /><div class='inputArea'>双击输入选项</div><input class='txtArea' type='text' /></div><div><input type='radio' /><div class='inputArea'>双击输入选项</div><input class='txtArea' type='text' /></div></div>";

    var insert3 = "<div class='insertBox'><span class='delete'></span><div class='inputArea'>双击输入问题</div><input class='txtArea' type='text' /><div><input type='checkbox' /><div class='inputArea'>双击输入选项</div><input class='txtArea' type='text' /></div><div><input type='checkbox' /><div class='inputArea'>双击输入选项</div><input class='txtArea' type='text' /></div></div>";


    $("#close_flash").click(function(){
        $("#flash_field").hide();
        $(".tab_alert").hide();
    });
    $("#flash_field").fadeOut(2000);
    $(".addElemt1").click(function() {
        $(".insertDiv").append(insert1);
    });
    $(".addElemt2").click(function() {
        $(".insertDiv").append(insert2);
    });
    $(".addElemt3").click(function() {
        $(".insertDiv").append(insert3);
    });

    $(".formTit input").focus(function() {
        if ($(this).val() == "在这输入表单标题") {
            $(this).val("");
            $(this).css("color", "#2C2C2C");
        }
    });
    $(".formTit input").blur(function() {
        if ($(this).val() == "") {
            $(this).val("在这输入表单标题");
            $(this).css("color", "#A7A7A7");
        }
    });
    $(".insertDiv").on("dblclick", ".inputArea", function() {
        $(this).hide();
        $(this).parent().children(".txtArea").show();
        $(this).parent().children(".txtArea").focus();
    });

    $("tr").each(function() {
        var table = $(this).parents("table");
        var i = table.find("tr").index($(this));
        if (i % 2 == 0 && i != 0) {
            $(this).css("background", "#F2F6F6");
        }
    });

    $(".reload_record").on("click",".close",function(){
        $(".second_box").removeAttr("ishow");
        $(this).parents(".second_box").hide();
        $(".second_bg").hide();
        $("#fault").hide();
        $("#message_record").click();
    })
    $(".second_box .close").click(function() {
        $(".second_box").removeAttr("ishow");
        $(this).parents(".second_box").hide();
        $(".second_bg").hide();
        $("#fault").hide();
    });
    $("body").on("click",".abandon",function(){
        $(".second_box").removeAttr("ishow");
        $(this).parents(".second_box").hide();
        $(".second_bg").hide();
        $("#fault").hide();
        //        window.location.replace(location.href);
        $("#message_record").click();
    })
    //    $(".abandon").click(function(){
    //
    //        })

    $(".insertDiv").on("click", ".delete", function() {
        $(this).parent().remove();
    });

    $(".theTab").click(function() {
        $(".theTab").removeClass("used");
        $(".tabDiv").removeClass("used");
        $(this).addClass("used");
        var i = $(".theTab").index(this);
        //alert(i);
        $(".tabDiv").eq(i).addClass("used");
    });

    $(".check_input").blur(function() {
        if ($(this).val() == "") {
            $(this).parent().find(".check").css("color", "#ff0000");
        } else {
            $(this).parent().find(".check").css("color", "#ffffff");
        }
    });

    $("button.newPage").click(function() {
        $(".tabDiv").hide();
        $(".tabDiv.newPage").show();
    });

    $(".page_tit input").blur(function() {
        if ($(this).val() == "") {
            $(this).parent().find("span").css("color", "#ff0000");
        } else {
            $(this).parent().find("span").css("color", "#e9ebea");
        }
    });
    //显示创建站点

    $(".file_1").change(function() {
        $(this).parents(".fileBox").find(".fileText_1").val($(this).val());
    });
    $('#create').click(function() {
        $(this).parents(".second_box").hide();
        $('.second_bg').hide();
        $("#fault").hide();
    });
    
    $('#create_sub').click(function() {
        var name =$.trim( $('#site_name').val());
        var root = $.trim( $('#site_root_path').val() );
        var cweb = $.trim($('#site_cweb').val());
        if(root=='js'||root=='style'){
            tishi_alert('站点名不能js或者style');
            return false;
        }
        if (name.length == 0) {
            tishi_alert('站点名不能为空');
            return false;
        }
        if (root.length == 0) {
            tishi_alert('根目录不能为空');
            return false;
        }
        if (root.match(/[^a-zA-Z]/i)) {
            tishi_alert('根目录只能为字母');
            return false;
        }
        $("#fault").show();
    });
    
    
    $(".third_box .close").click(function(){
        $(this).parents(".third_box").hide();
        $(".third_bg").hide();
    });
	
    $("body").on("click",".thd_btn",function(){
        $(".third_bg").show();
        $(".third_box."+$(this).attr("name")).show();
    });
	
    $(".second_box .close").click(function(){
        if(!$(this).parents(".second_box").hasClass("third_box")){
            $(this).parents(".second_box").hide();
            $(".second_bg").hide();
        }
		
    });
	
    $("body").on("click",".scd_btn",function(){
        //   $(".second_bg").show();
        $(".second_box."+$(this).attr("name")).show();
        $(".second_box."+$(this).attr("name")).attr("ishow","show");
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
	
    $.each($(".category a li"),function(i,item){
        if(i%2 != 0){
            $(item).css("background","#53656c");
        }
    });
    $.each($(".nav_d li a"),function(i,item){
        if(i%2 != 0){
            $(item).css("background","#53656c");
        }
    });
	
    
    $(".newSmlPic").click(function(){
        var i = $(".smlPicList .smlPic").length;
        $(".smlPicList").append("<div class='smlPic'><a class='scd_btn' name='addLink'>"+Number(i+1)+"</a><span class='close'></span></div>");
    });
	
    $("tr").each(function(){
        var table = $(this).parents("table");
        var i = table.find("tr").index($(this));
        if(i % 2 ==0 && i != 0){
            $(this).css("background","#F2F6F6");
        }
    });
	
    $(".insetBox").on("click",".optBox .close2",function(){
        $(this).parents(".optBox").remove();
    });
    $("body").on("click",".warnArea .time",function(){
        var txtArea = $(this).parents(".warnArea").find(".warnTxt textarea");
        txtArea.val(txtArea.val() + "[[时间]]");
    })
    $("body").on("click",".warnArea .space",function(){
        var txtArea = $(this).parents(".warnArea").find(".warnTxt textarea");
        txtArea.val(txtArea.val() + "[[填空]]");
    })
    $("body").on("click",".radioSpan",function(){
        $(this).parent().find("input[name='send_time']").click();
        $(this).parent().find("input[name='user_select']").click();
        $(this).parent().parent().find(".radioBox1").removeClass("check");
        $(this).parent().addClass("check");
        $(this).parents(".labRight").find("input[type='text']").attr("disabled","disabled");
        $(this).parents(".labRight").find("input[type='text']").val("")
        $(this).parent().find("input[type='text']").removeAttr("disabled");
    })
})
//显示创建站点
function create_site(template) {
    $(".second_bg").show();
    $(".second_box.new_point").show();
    $("#site_titile").html('创建站点（根目录创建后不可修改）');
    $('#site_edit_or_create').val('create');
    $('#site_root_path').removeAttr("readonly");
    is_exist_app(false);
    $('#must_fix').show();
    text_value("", '', '');
    $("#template").val(template);
}

//显示编辑页面
function show_edit_page(name, rootpath, notes, cweb, username, pwd,exist_app) {
    $(".second_bg").show();
    $(".second_box.new_point").show();
    $("#site_titile").html('编辑站点');
    $('#site_edit_or_create').val('edit');
    $('#site_root_path').attr("readonly", "readonly");
    $('#site_root_path').css('background', '#C7C7C7');
    is_exist_app(exist_app,username,pwd);
    $('#must_fix').hide();
    text_value(name, rootpath, notes, cweb);
}
//是否存在app账号
function is_exist_app(exist_app,username,pwd){
    var radio = $('input[type=radio]');
    if(exist_app){
        $(radio[1]).removeAttr("checked");
        $(radio[0]).attr("checked",true);
        $('#username').val(username);
        $('#password').val(pwd);
    }else{
        $(radio[0]).removeAttr("checked");
        $(radio[1]).attr("checked",true);
    //$('#username').val("");
    // $('#password').val("");
    }
}

function text_value(name, rootpath, notes, cweb) {

    $('#site_name').val(name);
    $('#origin_name').val(name);
    $('#site_root_path').val(rootpath);
    $('#site_notes').val(notes);
    $('#site_cweb').val(cweb);
}

function doAjax(keyname, key, path) {
    if ($("#hereis") != null) {
        $.ajax({
            url : path + "?" + keyname + "=" + key
        }).done(function(date) {
            //$("#hereis").html("<ul><% @spe_cons.each do |s|%><%user=User.find(s.user_id)%><li><font color='red'><%=user.name%></font>说：<span><%=s.context%></span></li><%end%></ul>");
            $("#hereis").html(date);
        });
    }
}

function have_exist(id) {
    var name = $("#resource_c").val();
    if (name == "") {
        tishi_alert('请选择文件');
        return false;
    } else {
        var pattern = new RegExp("[`~@#$^&*()=:;'\",\\[\\]<>~！%￥…&*（）|{}。，、]");
        var arr = ['zip', 'ZIP', 'jpg', 'JPG', 'jpeg', 'JPEG', 'png', 'PNG', 'mp3', 'MP3', 'wma', 'WMA', '3gp', '3GP', 'mp4', 'MP4', 'swf', 'SWF', 'gif', 'GIF', 'js', 'JS', 'css', 'CSS'];
        /* var name1 = name.split("\\");
        name1 = name1[name1.length-1];
        if(pattern.test(name1)){
            tishi_alert("文件名不能包含特殊字符");
            return false;
        }*/
        if (arr_contant(name, arr)) {

            name = name.split('\\');
            name = name[name.length - 1];

            $.ajax({
                async : true,
                type : 'get',
                url : '/check_zip',
                dataType : "json",
                data : "name=" + name + "&id=" + id,
                success : function(data) {
                    if (data.status == 1) {
                        $("#fugai").show();
                        $("#fugai1").show();
                        $("#uploadForm").submit();

                    } else {
                        //alert("已经存在资源!是否上传");
                        if (confirm('已经存在资源!是否上传')) {
                            $("#uploadForm").submit();
                        }
                    }
                }
            });
        } else {
            tishi_alert('不合法文件，只能是\n视频(mp4,swf,3gp)<50M\n音频(mp3,wav,wma)<20M\n图片(jpg,png,gif)<2M\n或(zip)压缩包,js/css文件');
            return false;
        }
    }
}

function change_status(id, statu, msg) {
    var status = 2
    $.ajax({
        async : true,
        type : 'get',
        url : '/change_status',
        dataType : "text",
        data : "status=" + status + "&id=" + id,
        success : function(data) {
            if (msg != "")
                if (data == 1) {
                    tishi_alert(msg + "成功！");
                    setTimeout("window.location.reload()", 800);
                //window.location.reload();
                } else {
                    tishi_alert(msg + "失败！");
                }
        }
    });
}

function arr_contant(name, arr) {
    perfix_name = name.split('.');
    perfix_name = perfix_name[perfix_name.length - 1];

    for (var i = 0; i < arr.length; i++) {
        if (arr[i] == perfix_name)
            return true;
    }
    return false;
}

function check_form_particular(id) {
    var content = $("#" + id).val();
    regex = /\~\!\@\#\$\%\^\&\*/;
    if (!content.match(regex)) {
        tishi_alert('有非法字符！')
    }
}

function show_center(t) {
    var content = $(t).parents(".second_box")
    var mouse_position = document.body.scrollTop + document.documentElement.scrollTop;
    var doc_height = $(document).height();
    var doc_width = $(document).width();
    var layer_height = $(t).height();
    var layer_width = $(t).parent(".second_content").width();
    var win_height = $(window).height();

    content.css('top', mouse_position + 100 + "px");
    content.css('left', (doc_width - layer_width) / 2);

    $(t).parent(".second_content").show();
    content.show();
    $(".second_bg").show();
    content.find(".close").click(function() {
        hide_tab($(t));
    });
}

//提示错误信息
function tishi_alert(message) {
    $(".alert_h").html(message);
    var tab = $(".tab_alert");
    var scolltop = document.body.scrollTop|document.documentElement.scrollTop; //滚动条高度
    var win_height = $(document).height();
    var z_layer_height = $(".tab_alert").height();
    tab.css('top', 100 + scolltop);
    var doc_width = $(document).width();
    var layer_width = $(".tab_alert").width();
    tab.css('left', (doc_width - layer_width) / 2);
    tab.css('display', 'block');
    tab.fadeTo("slow", 1);
    $(".tab_alert .close").click(function() {
        tab.css('display', 'none');
    })
    setTimeout(function() {
        tab.fadeTo("slow", 0);
    }, 4000);
    setTimeout(function() {
        tab.css('display', 'none');
    }, 4000);

}


$(".msgBoxEdit").on("click", function() {
    $(this).parents(".tabDiv").removeClass("used");
    $(".tabDiv:last").addClass("used");
});

$(".autoReplyBox").on("click", function() {
    if ($(this).hasClass("showAll")) {
        $(".autoReplyBox").removeClass("showAll");
    } else {
        $(".autoReplyBox").removeClass("showAll");
        $(this).addClass("showAll");
    }
});

function search_site() {
    location.href = '/search_sites?key=' + $("#site_key").val();
}

function interception_wrap(button){
    var s = $(button).parents(".third_content").find("textarea").val();
    var array_s = s.split("\n");
    var activity = null;
    var long_size = true;
    $.each(array_s,function(index,value){
        value = $.trim(value);
        if (value.length >= 17){
            tishi_alert('单行字符过长！')
            long_size = false;
            return false;
        }
        if(activity==null){
            activity = value;
        }else{
            activity += "||"+ value;
        }
    });
    if (long_size){
        var txtArea = $("div[ishow='show']").find(".warnTxt textarea");
        txtArea.val(txtArea.val() + "[[选项-"+ activity +"]]")
        $(button).parents(".third_box").hide();
        $(".third_bg").hide();
    }
}
Date.prototype.format =function(format)
{
    var o = {
        "M+" : this.getMonth()+1, //month
        "d+" : this.getDate(), //day
        "h+" : this.getHours(), //hour
        "m+" : this.getMinutes(), //minute
        "s+" : this.getSeconds(), //second
        "q+" : Math.floor((this.getMonth()+3)/3), //quarter
        "S" : this.getMilliseconds() //millisecond
    }
    if(/(y+)/.test(format)) format=format.replace(RegExp.$1,
        (this.getFullYear()+"").substr(4- RegExp.$1.length));
    for(var k in o)if(new RegExp("("+ k +")").test(format))
        format = format.replace(RegExp.$1,
            RegExp.$1.length==1? o[k] :
            ("00"+ o[k]).substr((""+ o[k]).length));
    return format;
}
function check_remind_nonempty(){
    var todays = new Date().format('yyyy-MM-dd')
    if($.trim($("input[name='remind_name']").val()).length == 0){
        tishi_alert('提示:\n\n名称不能为空');
        return false;
    } else if($.trim($("input[name='free_time']").val()).length == 0 && $.trim($("input[name='dayfor_time']").val()).length == 0){
        tishi_alert('提示:\n\n请选择发送时间');
        return false;
    }else if($.trim($("textarea[name='remind_content']").val()).length == 0){
        tishi_alert('提示:\n\n内容不能为空');
        return false;
    }else if($.trim($("input[name='free_time']").val())<= todays && $.trim($("input[name='dayfor_time']").val()) <= 0){
        tishi_alert('提示:\n\n请选择正确时间');
        return false;
    }
}
function check_record_nonempty(){
    if($.trim($("input[name='records_title']").val()).length == 0){
        tishi_alert('提示:\n\n名称不能为空');
        return false;
    }else if($.trim($("textarea[name='records_content']").val()).length == 0){
        tishi_alert('提示:\n\n内容不能为空');
        return false;
    }
}