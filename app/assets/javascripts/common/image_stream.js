/* 
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

//增加一个空白区域
function add() {
    var li = $("<li class='ui-widget-content ui-corner-tr' style='width: 186px;'></li>");
    li.html("<div style='height:144px;' ><img  src='/assets/temp.jpg' style='width:182px;height:144px; '/></div><a  title='Delete this image' onclick='delete_ele(this)'  class='ui-icon ui-icon-trash'>Delete image</a><textarea></textarea><input type='hidden' name='temp_picture' />");
    candrop(li);
    li.appendTo($("#trashh"));
}
//新版增加一个区域
function add_imgstream_item(){
    var len = $(".picStream").find(".picStrBox").length;
    var div = $("<div class='picStrBox'><span class='close' onclick='delete_ele(this)'></span><div class='imgDiv'><span>"+(len+1)+"</span><input type='hidden' class='temp_picture' /></div><textarea></textarea><input type=\"hidden\" name=\"pic_text[]\" /></div>");
    var span = $(div).find(".imgDiv").find("span");
    can_it_drop(span);
    $(".picStream").append(div);
}

function can_it_drop(obj){
    obj.droppable({
        accept: ".picRes > .picBox",
        activeClass: "ui-state-highlight",
        drop: function( event, ui ) {
            var img = ui.draggable.find("img");
            var width_or_height = setImageWH( img, $(img).width(), $(img).height() );
            var img_src = img.attr("src");
            $(this).html("<img src='"+img_src+"' "+ width_or_height +"/>");
            $(this).parent().find(".temp_picture").val(img_src);
            
        }
    });
}


//删除图片
function delete_ele(element) {
    //获取父节点并移除
    var filename=$(element).parent();
    var src=$(filename).find(".imgDiv").find("span").children("img").length;
    if(src != 0 ){
        if(confirm("是否删除？")){
            $(element).parent().remove();
        }
    }else{
        $(element).parent().remove();
    }

}


function replace_chart(arr,text){
	for(var i=0;i<arr.length;i++){
		alert("/"+ arr[i] +"/g");
		text = text.replace(/[>&<'"]/g, function(x) { return "&#" + x.charCodeAt(0) + ";"; });
		text.replace("/\\"+ arr[i] +"/g","\\"+arr[i]);
		alert(text);
	}
	return text;
	
}
//提交imgstream
function submit_imgstream(){
    var title = $.trim($("#title").val());
    var name = $.trim($("#name").val());
    if (title == "" || name == "") {
        tishi_alert("标题，文件名不能为空！");
        return false;
    }
    if (!name.match(/^[a-z]/i)) {
        tishi_alert("文件名不能为非字母！");
        return false;
    }
    var src = "";
    var text = "";
    var flag = true;
    var divArr = $(".picStrBox");
    //将有效图片存入字符串
    var pattern = new RegExp("[`~@#$^&*()=:\\[\\].<>~！%@#￥……&*——|{}。，、-]");
 
    $.each(divArr, function(index, name) {
        if (index < divArr.length) {
            if ($(name).find('img').length !=0) {
                src += $(name).find(".temp_picture").val() + ",";
                var textarea_txt=$(name).find('textarea').val();
                $(name).children('input[type=hidden]').val(textarea_txt);
               // var tex_txt = textarea_txt.replace(/[`~@#$^&*()=:\[\].<>~！%@#￥……&*——|{}。，、-]/g,  function(x){ return "\&#" + x.charCodeAt(0) + "\;"; });
               //text += tex_txt + "||";
                //alert(text);

            } else {
                flag = false;
            }
        }
    });
    if (!flag) {
        tishi_alert('存在未填充区域！');
        return false;
    }
    if(src==""){
        tishi_alert('图片流页不能为空');
        return false;
    }
    var form_data = $(".pic_form").serialize();
    if ($("#page_type").val() == 'edit') {
        $.ajax({
            //async : true,
            headers : {
                'X-Transaction' : 'POST Example',
                'X-CSRF-Token' : $('meta[name="csrf-token"]').attr('content')
            },
            type : 'post',
            url : '/imgtxt_edit_update',
            dataType : "json",
            data : 'title=' + title + '&name=' + name + '&src=' + src+'&site_id=' + $("#site_id").val() + "&id=" + $("#page_id").val() + '&'+form_data,
            success : function(data) {
                if (data == 1) {
                    tishi_alert("更新成功");
                    location.href='/sites/'+$("#site_id").val()+'/image_streams/img_stream';
                //返回主页
                //location.href = "/sites/" + $("#site_id").val() + "/image_streams/img_stream";
                } else {
                    tishi_alert("更新失败");
                }
            }
        });
    } else {
        $.ajax({
            //async : true,
            headers : {
                'X-Transaction' : 'POST Example',
                'X-CSRF-Token' : $('meta[name="csrf-token"]').attr('content')
            },
            type : 'post',
            url : '/image_text_page',
            dataType : "json",
            data : 'title=' + title + '&name=' + name + '&check=' + 0 + '&src=' + src + '&text=' + text + '&site_id=' + $("#site_id").val()+ '&'+form_data,
            success : function(data) {
                if (data == 1) {
                    tishi_alert("创建成功");
                    location.href='/sites/'+$("#site_id").val()+'/image_streams/img_stream';
                } else {
                    tishi_alert("创建失败，已存在文件名");
                }
            }
        });
    }


}
//提交
function submit_btn() {
    //去掉空格
    var title = $.trim($("#title").val());
    var name = $.trim($("#name").val());
    if (title == "" || name == "") {
        tishi_alert("标题，文件名不能为空！");
        return false;
    }
    if (!name.match(/^[a-z]/i)) {
        tishi_alert("文件名不能为非字母！");
        return false;
    }
    var arr = $("*[name='w']");
    var check = "";
    for (var i = 0; i < arr.length; i++) {
        if (arr[i].checked) {
            check = arr[i].value;
            break;
        }
    }
    var src = "";
    var text = "";
    var ul = $("#trash");
    var flag = true;
    var liArr = $("#trash").children("ul").children("li");
    //将有效图片存入字符串
    var pattern = new RegExp("[`~@#$^&*()=:\\[\\].<>~！%@#￥……&*（）——|{}。，、-]");
    $.each(liArr, function(index, name) {
        if (index < liArr.length) {
            if ($(name).find('img').attr("src") != "/assets/temp.jpg") {
                src += $(name).find('input').val() + ",";
                textarea_txt=$(name).find('textarea').val();
                if($.trim(textarea_txt)!= "" && pattern.test(textarea_txt)){
                    tishi_alert("内容不能包含非法字符");
                    return fasle;
                }
                text += textarea_txt + "||";

            } else {
                flag = false;
            }
        }
    });
    if (!flag) {
        tishi_alert('存在未填充区域！');
        return false;
    }
    if(src==""){
        tishi_alert('图片流页不能为空');
        return false;
    }

    if ($("#page_type").val() == 'edit') {
        $.ajax({
            //async : true,
            headers : {
                'X-Transaction' : 'POST Example',
                'X-CSRF-Token' : $('meta[name="csrf-token"]').attr('content')
            },
            type : 'post',
            url : '/imgtxt_edit_update',
            dataType : "json",
            data : 'title=' + title + '&name=' + name + '&check=' + check + '&src=' + src + '&text=' + text + '&site_id=' + $("#site_id").val() + "&id=" + $("#page_id").val(),
            success : function(data) {
                if (data == 1) {
                    tishi_alert("更新成功");
                    location.reload();
                //返回主页
                //location.href = "/sites/" + $("#site_id").val() + "/image_streams/img_stream";
                } else {
                    tishi_alert("更新失败");
                }
            }
        });
    } else {
        $.ajax({
            //async : true,
            headers : {
                'X-Transaction' : 'POST Example',
                'X-CSRF-Token' : $('meta[name="csrf-token"]').attr('content')
            },
            type : 'post',
            url : '/image_text_page',
            dataType : "json",
            data : 'title=' + title + '&name=' + name + '&check=' + check + '&src=' + src + '&text=' + text + '&site_id=' + $("#site_id").val(),
            success : function(data) {
                if (data == 1) {
                    tishi_alert("创建成功");
                    location.reload();
                } else {
                    tishi_alert("创建失败，已存在文件名");
                }
            }
        });
    }
}

function cancle_dialog(){
    $(".newPage").hide();
    $(".second_bg").hide();

}