/* 
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

//鼠标在上面时显示 蒙板
function showMask(obj){
    $(obj).find(".appmsg_mask").show();
}

//鼠标离开时隐藏 蒙板
function hideMask(obj){
    if($(obj).find(".icon_appmsg_selected").css("display") == "none")
    {
        $(obj).find(".appmsg_mask").hide();
    }
}

//弹出框选择图文
function selectBox(obj){
    $("#micro_image_text").find(".msgBox").removeClass("selected");
    $("#micro_image_text").find(".msgBox .appmsg_mask").hide();
    $("#micro_image_text").find(".msgBox .icon_appmsg_selected").hide();
    $(obj).find(".appmsg_mask").show();
    $(obj).find(".icon_appmsg_selected").show();
    $(obj).addClass("selected")
}

var image_text_del_cover = '<div class="msgBoxAct">\n\
                               <div class="msgBoxDel" title="删除" onclick="delImagetext(this)"></div>\n\
                            </div>';
var text_del_cover = '<div class="wzxxBox">\n\
                            <span></span>\n\
                            <div class="wzxxBoxAct">\n\
                                    <div class="wzxxBoxDet" title="删除" onclick="delText(this)"></div>\n\
                            </div>\n\
                       </div>'
//自动回复弹出框选定文字 or 图文
function setAutoChoose(obj, flag, location){
    if(flag == 0){  //图文
        var selectBlock = obj.find(".selected");
        var html = selectBlock.parent().html();
        $(".auto_message").html(html);
        $(".auto_message").find(".appmsg_mask").remove();
        $(".auto_message").find(".icon_appmsg_selected").remove();
        $(".auto_message").find(".msgBox").append(image_text_del_cover);
    }else{ //文字
        var text = obj.find(".micro_text").val();
        $(".auto_message").html(text_del_cover);
        $(".auto_message").find(".wzxxBox span").text(text);
    }
    hide_tab(obj);
}

//关键字回复/自动回复  弹出框选定文字 or 图文
function setChoose(obj, flag, location){
    var li = $("." + location).find(".auto_message");
    if(flag == "imagetext"){  //图文
        var selectBlock = obj.find(".selected");
        var html = selectBlock.parent().html();
        li.html(html);
        li.find(".appmsg_mask").remove();
        li.find(".icon_appmsg_selected").remove();
        li.find(".msgBox").append(image_text_del_cover);
    }else if(flag == "text"){ //文字
        var text = obj.find(".micro_text").val();
        text = HTMLEnCode(text);
        li.html(text_del_cover);
        li.find(".wzxxBox span").text(text);
    }else if(flag == "ggl"){
        var ggl = obj.find("input.ggl_link:checked");
        if(ggl.length > 0){
            var ggl_link = ggl.val();
            text = HTMLEnCode(ggl_link);
            li.html(text_del_cover);
            li.append("<input type='hidden' value='ggl' class='solid_link_flag'/>");
            li.find(".wzxxBox span").text(text);
        }
        
    }else if(flag == "app"){
        var app = obj.find("input.app_link:checked");
        if(app.length > 0){
            var app_link = app.val();
            text = HTMLEnCode(app_link);
            li.html(text_del_cover);
            li.append("<input type='hidden' value='app' class='solid_link_flag'/>");
            li.find(".wzxxBox span").text(text);
        }
    }
    hide_tab(obj);
}

//选定在框中之后还可以移除掉
function delImagetext(obj){
    if(confirm("确定移除？")){
        $(obj).parents(".msgBox").remove();
    }
}

function delText(obj){
    if(confirm("确定移除？")){
        $(obj).parents(".wzxxBox").remove();
    }
}

//消息列表展开 or 收起
function toggleDetail(obj){
    if($(obj).text() == "展开"){
        // $(obj).text("收起");
        $(obj).parents(".autoReplyBox").next().toggle();
    }else{
        //$(obj).text("展开");
        $(obj).parents(".autoReplyBox").prev().toggle();
    }
    $(obj).parents(".autoReplyBox").toggle();
    
}

var keywordBlock = '<li>\n\
  <div class="autoReplyBox" style="display:none">\n\
    <div class="arItem cf">\n\
      <label>关键字：</label>\n\
      <div>\n\
      </div>\n\
    </div>\n\
    <div class="arItem cf">\n\
      <label>回复内容：</label>\n\
      <div><span></span></div>\n\
    </div>\n\
      <div class="toggleAct">\n\
      <button class="blue_btn" onclick="delLi(this)">删除</button>\n\
      <button class="blue_btn" onclick="toggleDetail(this)">展开</button>\n\
    </div>\n\
</div>\n\
  <div class="autoReplyBox">\n\
    <div class="arItem cf">\n\
      <label>关键字：</label>\n\
      <div><input type="text"class="keyword" name="keyword" value="" />（多个请用逗号或者空格分隔）</div>\n\
    </div>\n\
    <div class="arItem">\n\
      <label>回复内容：</label>\n\
      <div>\n\
        <div>\n\
          <button class="blue_btn add_text">添加文字</button>\n\
          <button class="blue_btn add_imagetext">添加图文</button>\n\
          <button class="blue_btn add_ggl">添加刮刮乐链接</button>\n\
          <button class="blue_btn add_app">添加app链接</button>\n\
        </div>\n\
        <div class="auto_message">\n\
        </div>\n\
      </div>\n\
    </div>\n\
    <div class="autoReplyBoxAct arItem">\n\
      <label>&nbsp;</label>\n\
      <button class="blue_btn save_btn">保存</button>\n\
    </div>\n\
    <div class="toggleAct">\n\
      <button class="blue_btn" onclick="delLi(this)">删除</button>\n\
      <button class="blue_btn" onclick="toggleDetail(this)">收起</button>\n\
    </div>\n\
</div>\n\
</li>'

//添加关键字回复
function appendNewKeyword(site_id){
    $(".keyword_list").append(keywordBlock);
    var li_length = $(".keyword_list").find("li").length;
    current_li = $(".keyword_list").find("li").last();
    current_li.attr("class", "key_" + li_length);
    //添加文字按钮点击事件
    current_li.find(".add_text").bind("click", function(){
        show_tag($('#micro_text'), "key_" + li_length, 'text');
    });
    //添加图文按钮点击事件
    current_li.find(".add_imagetext").bind("click", function(){
        show_tag($('#micro_image_text'), "key_" + li_length, 'imagetext');
    });
    //添加刮刮乐按钮点击事件
    current_li.find(".add_ggl").bind("click", function(){
        show_tag($('#ggl_pop'), "key_" + li_length, 'ggl');
    });
    //添加app按钮点击事件
    current_li.find(".add_app").bind("click", function(){
        show_tag($('#app_pop'), "key_" + li_length, 'app');
    });
    //设置保存按钮 路由
    current_li.find(".save_btn").bind("click", function(){
        saveAutoReply(this, '/sites/' + site_id + '/weixin_replies', 'keyword', 'new')
    });
}

function saveAutoReply(obj, url, auto_or_keyword, new_or_edit, li_index){
    var autoMessage = $(obj).parents(".autoReplyBox").find(".auto_message");
    var keywordEle = $(obj).parents(".autoReplyBox").find(".keyword");
    if($.trim(autoMessage.html()) == ""){
        tishi_alert("内容不能为空！")
    }else{
        var micro_message = autoMessage.find(".micor_message_id");
        var micro_message_id = "";
        var text = "";
        var solid_link_flag = "";
        var flag = auto_or_keyword;
        var keyword = keywordEle ? keywordEle.val() : "";
        var li_index = li_index ? li_index : -1;
        if(micro_message.length != 0){
            micro_message_id = micro_message.val();
        }else{
            text = $.trim(autoMessage.text());
            solid_link_flag = autoMessage.find(".solid_link_flag").val();
        }
        $.ajax({
            url: url,
            type: new_or_edit == "new" ? "POST" : "PUT",
            dataType: "script",
            data: {
                micro_message_id: micro_message_id,
                text: text,
                flag: flag,
                keyword: keyword,
                index: li_index,
                solid_link_flag: solid_link_flag
            },
            success:function(data){
            //tishi_alert("保存成功")
            // window.location.reload();
            },
            error:function(data){
            //alert("error");
            }
        })
    }
}
//关键字未保存 删除
function delLi(obj){
    if(confirm("确定移除？")){
        $(obj).parents("li").remove();
    }
}
//转义字符串
function HTMLEnCode(str)
{
    var    s    =    "";
    if    (str.length    ==    0)    return    "";
    s    =    str.replace(/&/g,    "&gt;");
    s    =    s.replace(/</g,        "&lt;");
    s    =    s.replace(/>/g,        "&gt;");
    s    =    s.replace(/    /g,        "&nbsp;");
    s    =    s.replace(/\'/g,      "&#39;");
    s    =    s.replace(/\"/g,      "&quot;");
    s    =    s.replace(/\n/g,      "<br>");
    return    s;
}