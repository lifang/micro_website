/* 
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

//判断非法字符
var pattern = new RegExp("[`~@#$^&*()=:;,\\[\\].<>~！%@#￥……&*（）——|{}。，、-]");
var patten_html = new RegExp("[.]");

//表单元素

var input_ele = "<div class=\"itemBox inputBox\">\n\
                   <span class=\"close\"></span>\n\
                   <label></label><input type=\"text\" />\n\
                   <input type=\"hidden\" class=\"hidden_label\"/>\n\
                 </div>";
var radio_ele = "<div class=\"itemBox radioBox\">\n\
                    <span class=\"close\"></span>\n\
                    <div class='label'><span></span><input type=\"hidden\" class=\"hidden_label\"/></div>\n\
                </div>"
var radio_option = "<div class=\"opt rad\"><input type=\"radio\" /><input type=\"hidden\" class=\"hidden_option\"/><span></span></div>"

var checkbox_ele = "<div class=\"itemBox checkboxBox\">\n\
			<span class=\"close\"></span>\n\
            <div class='label'><span class=\"label_value\"></span><input type=\"hidden\" class=\"hidden_label\"/></div>\n\
	            </div>"
var checkbox_option = "<div class=\"opt chk\"><input type=\"checkbox\" /><input type=\"hidden\" class=\"hidden_option\"/><span></span></div>"

var select_ele = "<div class=\"itemBox selectBox\">\n\
                        <span class=\"close\"></span>\n\
			<label></label><select></select>\n\
		        <input type=\"hidden\" class=\"hidden_label\"/>\n\
                 </div>"
var select_option = "<option></option>"

var select_hidden_option = "<input type=\"hidden\" class=\"hidden_option\"/>"

$(function(){
    //弹出增加表单元素的框
    $(".formAct button").on('click', function(){
        var pop_id = $(this).attr("data-ele");
        show_tag($("#" + pop_id))
    });
    //弹出框里面点击确定，增加表单元素
    $(".addItem").on("click",".addItemInput",function(){
        var item = $(this).parents(".addItem");
        var input = $(item).find(".insetBox input").val();
        if($.trim(input)==""){
            tishi_alert("您还未输入内容！")
        }else{
            var input_length = $(".iphoneVirtual .form_ele").find(".inputBox").length;
            if(input_length!=0){
                var last_input_box = $(".iphoneVirtual .form_ele").find(".inputBox").last()
                input_length = last_input_box.find("input.hidden_label").attr("name").split("_")[1][0];
                input_length = parseInt(input_length) + 1;
            }
            $(".iphoneVirtual .form_ele .iphvAct").before(input_ele);
            var new_input_ele = $(".iphoneVirtual .form_ele").find(".inputBox").last();
            new_input_ele.find("label").text(input);    //label设置值
            new_input_ele.find("input.hidden_label").attr("name", "labels[input_" + input_length + "]");
            new_input_ele.find("input.hidden_label").val(input);
            hide_tab($("#input_pop"));
            $(".itemBox").on("click",".close",function(){
                if(confirm("确定移除吗？")){
                    $(this).parents(".itemBox").remove()
                }
            });
        }
    });

    //增加radio或者checkbox元素
    $(".addItem").on("click",".addItemRC",function(){
        var item = $(this).parents(".addItem");
        var flag = true;
        $(item).find(".insetBox input").each(function(){
            if($.trim($(this).val())==""){
                tishi_alert("有输入框未输入！");
                flag = false;
                return false;
            }
        });
        if(flag){
            var rc_label = $(item).find(".insetBox .label input").val();
            var input_options = $(item).find(".insetBox .optBox input");
            var box_ele = item.find("#checkbox_pop").length == 0? "radioBox" : "checkboxBox";
            var rc_length = $(".iphoneVirtual .form_ele").find("." + box_ele).length;
            if(rc_length!=0){
                var last_input_box = $(".iphoneVirtual .form_ele").find("." + box_ele).last();
                rc_length = last_input_box.find(".label .hidden_label").attr("name").split("_")[1][0];
                rc_length = parseInt(rc_length) + 1;
            }
            $(".iphoneVirtual .form_ele .iphvAct").before(box_ele == "radioBox" ? radio_ele : checkbox_ele);
            var new_radio_ele = $(".iphoneVirtual .form_ele").find("." + box_ele).last();
            new_radio_ele.find(".label span").text(rc_label); //label设置值
            new_radio_ele.find(".label .hidden_label").attr("name", "labels[" + (box_ele == "radioBox" ? "radio" : "checkbox") + "_" + rc_length +"]"); //设置label隐藏域的值
            new_radio_ele.find(".label .hidden_label").val(rc_label)
            input_options.each(function(){
                new_radio_ele.append(box_ele == "radioBox" ? radio_option : checkbox_option);
                var new_option = new_radio_ele.find(".opt").last();
                new_option.find("span").text($(this).val());
                new_option.find("input.hidden_option").attr("name", "options[" + (box_ele == "radioBox" ? "radio" : "checkbox") +"_" + rc_length + "][]");
                new_option.find("input.hidden_option").val($(this).val());
            })
            hide_tab($("#" + (box_ele == "radioBox" ? "radio_pop" : "checkbox_pop")));
            $(".itemBox").on("click",".close",function(){
                if(confirm("确定移除吗？")){
                    $(this).parents(".itemBox").remove()
                }
            });
        }
    });

    //增加select元素
    $(".addItem").on("click",".addItemSelect",function(){
        var item = $(this).parents(".addItem");
        var flag = true;
        $(item).find(".insetBox input").each(function(){
            if($.trim($(this).val())==""){
                tishi_alert("有输入框未输入！");
                flag = false;
                return false;
            }
        });
        if(flag){
            var select_label = $(item).find(".insetBox .label input").val();
            var select_options = $(item).find(".insetBox .optBox input");
            var select_length = $(".iphoneVirtual .form_ele").find(".selectBox").length;
            if(select_length!=0){
                var last_input_box = $(".iphoneVirtual .form_ele").find(".selectBox").last();
                select_length = last_input_box.find("input.hidden_label").attr("name").split("_")[1][0];
                select_length = parseInt(select_length) + 1;
            }
            $(".iphoneVirtual .form_ele .iphvAct").before(select_ele);
            var new_select_ele = $(".iphoneVirtual .form_ele").find(".selectBox").last();
            new_select_ele.find("label").text(select_label); //label设置值
            new_select_ele.find("input.hidden_label").attr("name", "labels[select_" + select_length +"]"); //设置label隐藏域的值
            new_select_ele.find("input.hidden_label").val(select_label);
            select_options.each(function(){
                new_select_ele.find("select").append(select_option);
                new_select_ele.find("select").after(select_hidden_option);
                var new_option = new_select_ele.find("option").last();
                new_option.text($(this).val());
                new_select_ele.find(".hidden_option").first().attr("name", "options[select_" + select_length + "][]");
                new_select_ele.find(".hidden_option").first().val($(this).val());
            });
            hide_tab($("#select_pop"));
            $(".itemBox").on("click",".close",function(){
                if(confirm("确定移除吗？")){
                    $(this).parents(".itemBox").remove()
                }
            });
        }

    });

    $(".itemBox").on("click",".close",function(){
        if(confirm("确定移除吗？")){
            $(this).parents(".itemBox").remove()
        }
    });

    $(".vstContr").on("click",".vcItem", function(){
        $(this).parents(".vstContr").find(".vcItem").removeClass("check");
        $(this).parents(".vstContr").find("input").removeAttr("checked")
        $(this).addClass("check");
        $(this).find("input").attr("checked",true);
    });

});


function submit_form_page(obj, site_id){
    var content = $.trim($(".form_ele").html());
    var tf_flag = validatePageForm(content);
    content = content.replace(/;/g, "||"); //把分号替换掉，否则表单提交不完全，会被分号隔开
    var title = $.trim($("#page_title").val()); //拿到去空格的值
    var file_name = $.trim($("#page_file_name").val());
    var img=$("#page_img_path").val();
    var authenticate = $(".vstContr").find(".vcItem.check input").val();
    img=$.trim(img);
    if(img==""){
        tishi_alert('请拖入图片');
        return false;
    }
    $("#page_title")[0].value = title;    //将去空格的值赋回去
    $("#page_file_name")[0].value = file_name;

    if(tf_flag){
        //if(flag=="submit"){ //新建 或者编辑
        var dataValue;
        dataValue = $(obj).parents("form").serialize();
        dataValue = dataValue + "&page[page_html]=" + content + "&page[authenticate]=" + authenticate;
        $.ajax({
            url: $(obj).parents("form").attr("action"),
            type: "POST",
            dataType: "script",
            data:dataValue,
            success:function(data){

            },
            error:function(data){
            //alert("error")
            }
        })
    /*  }else{ //预览
            //img="<img src='"+img+"'/><br/>";
            $("#form_container #hiddenContentContainer").html('<input type="hidden" id="hiddenContent" name="page[content]"/>');
            $("#form_container form").attr("target", "_blank").attr("action", $(obj).attr("alt"));
            $("#form_container #hiddenContent").val(content);
            $("#form_container form").submit();
        }*/
    }
}
