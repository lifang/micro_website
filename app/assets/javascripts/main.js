$(function() {

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

    $(".second_box .close").click(function() {
        $(this).parents(".second_box").hide();
        $(".second_bg").hide();
        $("#fault").hide();
    });
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
        var name = $('#site_name').val();
        var root = $('#site_root_path').val();
        var cweb = $('#site_cweb').val();
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

})
 //显示创建站点
function create_site(template){
    $(".second_bg").show();
    $(".second_box.new_point"   ).show();
    $("#site_titile").html('创建站点（根目录创建后不可修改）');
    $('#site_edit_or_create').val('create');
    $('#site_root_path').removeAttr("readonly");
    $('#must_fix').show();
    text_value("", '', '');
    
    $("#template").val(template);
}
//显示编辑页面
function show_edit_page(name, rootpath, notes,cweb) {
    $(".second_bg").show();
    $(".second_box.new_point").show();
    $("#site_titile").html('编辑站点');
    $('#site_edit_or_create').val('edit');
    $('#site_root_path').attr("readonly","readonly");
    $('#site_root_path').css('background','#C7C7C7')
    $('#must_fix').hide();
    text_value(name, rootpath, notes,cweb);
}




function text_value(name, rootpath, notes,cweb) {

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

function have_exist(id){
    var name=$("#resource_c").val();
    if(name=="")
    {
        tishi_alert('请选择文件');
        return false;
    }
    else{
        
        var arr=['zip' ,'ZIP', 'jpg' ,'JPG','jpeg','JPEG', 'png' ,'PNG', 'mp3' ,'MP3','wma','WMA','3gp' ,'3GP','mp4','MP4','swf','SWF', 'gif','GIF','js','JS','css','CSS'];
        if( arr_contant(name,arr) ){
            
            name=name.split('\\');
            name=name[name.length-1];

            $.ajax({
                async:true,
                type : 'get',
                url:'/check_zip',
                dataType:"json",
                data  :"name=" + name + "&id=" + id,
                success:function(data){
                    if(data.status == 1){
                        $("#fugai").show();
                        $("#fugai1").show();
                        $("#uploadForm").submit();
                     
                    }else{
                        //alert("已经存在资源!是否上传");
                        if(confirm('已经存在资源!是否上传')){
                            $("#uploadForm").submit();
                        }
                    }
                }
            });
        }else{
            tishi_alert('不合法文件，只能是\n视频(mp4,swf,3gp)<50M\n音频(mp3,wav,wma)<20M\n图片(jpg,png,gif)<2M\n或(zip)压缩包,js/css文件');
            return false;
        }
    } 
}

function change_status(id,statu,msg){
    var status=2
    $.ajax({
        async:true,
        type : 'get',
        url:'/change_status',
        dataType:"text",
        data  :"status=" + status + "&id=" + id,
        success:function(data){
            if(msg!="")
                if(data == 1){
                    tishi_alert(msg+"成功！");
                    setTimeout("window.location.reload()",800);
                //window.location.reload();
                }else{
                    tishi_alert(msg+"失败！");
               
                }
        }
    });
}

function arr_contant(name,arr){
    perfix_name=name.split('.');
    perfix_name=perfix_name[perfix_name.length-1];
   
    for(var i=0;i<arr.length;i++){
        if (arr[i]==perfix_name)
            return true;
    }
    return false;
}

function check_form_particular(id){
    var content=$("#"+id).val();
    regex=/\~\!\@\#\$\%\^\&\*/;
    if(!content.match(regex)){
        tishi_alert('有非法字符！')
    }
}

function show_center(t){
    var content = $(t).parents(".second_box")
    var mouse_position = document.body.scrollTop+document.documentElement.scrollTop;
    var doc_height = $(document).height();
    var doc_width = $(document).width();
    var layer_height = $(t).height();
    var layer_width = $(t).parent(".second_content").width();
    var win_height =  $(window).height();
 
    content.css('top',mouse_position+100+"px" );
    content.css('left',(doc_width-layer_width)/2);

    $(t).parent(".second_content").show();
    content.show();
    $(".second_bg").show();
    content.find(".close").click(function(){
        hide_tab($(t));
    });
}

//提示错误信息
function tishi_alert(message){
    $(".alert_h").html(message);
    var scolltop = document.body.scrollTop|document.documentElement.scrollTop;
    var win_height = document.documentElement.clientHeight;//jQuery(document).height();
    var z_layer_height = $(".tab_alert").height();
    $(".tab_alert").css('top',(win_height-z_layer_height)/2 + scolltop);
    var doc_width = $(document).width();
    var layer_width = $(".tab_alert").width();
    $(".tab_alert").css('left',(doc_width-layer_width)/2);
    $(".tab_alert").css('display','block');
    jQuery('.tab_alert').fadeTo("slow",1);
    $(".tab_alert .close").click(function(){
        $(".tab_alert").css('display','none');
    })
    setTimeout(function(){
        jQuery('.tab_alert').fadeTo("slow",0);
    }, 4000);
    setTimeout(function(){
        $(".tab_alert").css('display','none');
    }, 4000);

}

$(".msgBoxEdit").on("click",function(){
    $(this).parents(".tabDiv").removeClass("used");
    $(".tabDiv:last").addClass("used");
});

$(".autoReplyBox").on("click",function(){
    if($(this).hasClass("showAll")){
        $(".autoReplyBox").removeClass("showAll");
    }else{
        $(".autoReplyBox").removeClass("showAll");
        $(this).addClass("showAll");
    }
});


function search_site(){
   location.href='/search_sites?key='+$("#site_key").val();
   
}