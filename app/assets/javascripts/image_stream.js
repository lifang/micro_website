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

  //删除图片
  function delete_ele(element) {
    //获取父节点并移除
    var filename=$(element).parent();
    var src=$(filename).find('img');
    if($(src).attr('src')!= "/assets/temp.jpg" ){
      if(confirm("是否删除？")){
        $(element).parent().remove();
      }
    }else{
      $(element).parent().remove();
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