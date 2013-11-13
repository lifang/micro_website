$(function() {

    var insert1 = "<div class='insertBox'><span class='delete'></span><div class='inputArea'>双击输入标题</div><input class='txtArea' type='text' /></div>";

    var insert2 = "<div class='insertBox'><span class='delete'></span><div class='inputArea'>双击输入问题</div><input class='txtArea' type='text' /><div><input type='radio' /><div class='inputArea'>双击输入选项</div><input class='txtArea' type='text' /></div><div><input type='radio' /><div class='inputArea'>双击输入选项</div><input class='txtArea' type='text' /></div></div>";

    var insert3 = "<div class='insertBox'><span class='delete'></span><div class='inputArea'>双击输入问题</div><input class='txtArea' type='text' /><div><input type='checkbox' /><div class='inputArea'>双击输入选项</div><input class='txtArea' type='text' /></div><div><input type='checkbox' /><div class='inputArea'>双击输入选项</div><input class='txtArea' type='text' /></div></div>";

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
    $(".scd_btn").click(function() {
        $(".second_bg").show();
        $(".second_box." + $(this).attr("name")).show();
        $("#site_titile").html('创建站点');
        $('#site_edit_or_create').val('create');
        text_value("", '', '');
    })

    $(".file_1").change(function() {
        $(this).parents(".fileBox").find(".fileText_1").val($(this).val());
    });
    $('#create').click(function() {
        $(this).parents(".second_box").hide();
        $('.second_bg').hide();
    });
    $('#create_sub').click(function() {
        var name = $('#site_name').val();
        var root = $('#site_root_path').val();
        var notes = $('#site_notes').val();
        if (name.length == 0) {
            alert('站点名不能为空');
            return false;
        }
        if (root.length == 0) {
            alert('根目录不能为空');
            return false;
        }
        if (!root.match(/[a-zA-Z]/i)) {
            alert('根目录只能为字母');
            return false;
        }
    });


})
function show_edit_page(name, rootpath, notes) {
    $(".second_bg").show();
    $(".second_box.new_point").show();
    $("#site_titile").html('编辑站点');
    $('#site_edit_or_create').val('edit');
    text_value(name, rootpath, notes);
}




function text_value(name, rootpath, notes) {

    $('#site_name').val(name);
    $('#site_root_path').val(rootpath);
    $('#site_notes').val(notes);
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
        alert('请选择文件');
        return false;
    }
    else{
        
        var arr=['zip', 'jpg', 'png', 'mp3', 'mp4', 'avi', 'rm' ,'rmvb', 'gif'] ;
        if( arr_contant(name,arr) ){
            
            name=name.split('\\');
            name=name[name.length-1];
            alert(name);
            //            $.ajax({
            //                url : '/check_zip?name='+name+"&id="+id
            //            }).done(function(date){
            //                alert(date);
            //                if(date==1)
            //                    alert('已经存在资源');
            //            });


            $.ajax({
            async:true,
            type : 'get',
            url:'/check_zip',
            dataType:"json",
            data  :"name=" + name + "&id=" + id,
        

            success:function(data){
                alert(1111111111111);
                if(data.status == 1){
                    alert("审查通过!");
                     button.val("已审查").attr("disabled",true).css("background-color","red");
                }else{
                    alert("审查不通过!");
                }
            }
        });

//            $.ajax({
//                type:'get',
//                url:'/check_zip',
//                data:{
//                    name:name,
//                    id:id
//                },
//                dataType:"text",
//                success: function(data){
//                    alert(1111111111111);
//                    alert(data);
//                    show(data);
//                },
//                complete:function(date){
//                    alert(date);
//                    if(date)
//                    alert('已经存在资源');
//                },
//                error:function(date,textStatus, errorThrown){
//                    alert(textStatus+"@"+errorThrown);
//                    if(date)
//                    alert('error已经存在资源');
//                }
//            })

   




        }else{
            alert('不合法文件，只能是视频，音频，图片，或(zip)压缩包');
            return false;
        }
    } 
       
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




