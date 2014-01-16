/* 
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
//flag=0 submit form, flag=1 preview

//判断非法字符
var pattern = new RegExp("[`~@#$^&*()=:;,\\[\\].<>~！%@#￥……&*（）——|{}。，、-]");
var patten_html = new RegExp("[.]");

//表单元素
var inputEle = "<div class='insertBox inputBox'>\n\
                  <span class='delete' onclick='deleOption(this)' title='移除栏目'></span>\n\
                  <div class='inputArea questionTitle' ondblclick='showInput(this)'>双击输入问题</div>\n\
                  <input class='txtArea textQuestion' type='text' onblur='hideInput(this, 0)' />\n\
                  <input type='text' class='newNameClass' />\n\
                </div>";

var radioEle = "<div class='insertBox radioBox'>\n\
                    <span class='delete' onclick='deleOption(this)' title='移除栏目'></span>\n\
                    <span class='add_option' onclick='addOption(this, 2)' title='添加选项'></span>\n\
                    <div class='inputArea questionTitle' ondblclick='showInput(this)'>双击输入问题</div>\n\
                    <input class='txtArea textQuestion' type='text' onblur='hideInput(this, 0)' />\n\
                    <div class='pr'>\n\
                        <input type='radio' class='newNameClass' />\n\
                        <div class='inputArea' ondblclick='showInput(this)'>双击输入选项</div>\n\
                        <input class='txtArea' type='text' onblur='hideInput(this, 1)'/>\n\
                        <span class='deleteOption' onclick='deleOption(this)' title='去除选项'></span>\n\
                    </div>\n\
                    <div class='pr'>\n\
                        <input type='radio' class='newNameClass' />\n\
                        <div class='inputArea' ondblclick='showInput(this)'>双击输入选项</div>\n\
                        <input class='txtArea' type='text' onblur='hideInput(this, 1)'/>\n\
                        <span class='deleteOption' onclick='deleOption(this)' title='去除选项'></span>\n\
                    </div>\n\
                </div>";

var checkboxEle = "<div class='insertBox checkboxBox'>\n\
                        <span class='delete' onclick='deleOption(this)' title='移除栏目'></span>\n\
                        <span class='add_option' onclick='addOption(this, 3)' title='添加选项'></span>\n\
                        <div class='inputArea questionTitle' ondblclick='showInput(this)'>双击输入问题</div>\n\
                        <input class='txtArea textQuestion' type='text' onblur='hideInput(this, 0)'/>\n\
                        <div class='pr'>\n\
                            <input type='checkbox' class='newNameClass'/>\n\
                            <div class='inputArea' ondblclick='showInput(this)'>双击输入选项</div>\n\
                            <input class='txtArea' type='text' onblur='hideInput(this, 1)'/>\n\
                            <span class='deleteOption' onclick='deleOption(this)' title='去除选项'></span>\n\
                        </div>\n\
                        <div class='pr'>\n\
                            <input type='checkbox' class='newNameClass'/>\n\
                            <div class='inputArea' ondblclick='showInput(this)'>双击输入选项</div>\n\
                            <input class='txtArea' type='text' onblur='hideInput(this, 1)'/>\n\
                            <span class='deleteOption' onclick='deleOption(this)' title='去除选项'></span>\n\
                        </div>\n\
                    </div>";

var selectEle = "<div class='insertBox selectBox'>\n\
                    <span class='delete' onclick='deleOption(this)' title='移除栏目'></span>\n\
                    <div class='titBox'>\n\
                        <span class='add_option' onclick='addOption(this, 4)' title='添加选项'></span>\n\
                        <div class='inputArea questionTitle' ondblclick='showInput(this)'>双击输入问题</div>\n\
                        <input class='txtArea textQuestion' type='text' onblur='hideInput(this, 0)' />\n\
                    </div>\n\
                    <div class='optionBox'>\n\
                        <div class='inputArea' ondblclick='showInput(this)'>双击输入选项</div>\n\
                        <input class='txtArea' type='text' onblur='hideInput(this, 1)'/>\n\
                        <span class='deleteOption' onclick='deleOption(this)' title='去除选项'></span>\n\
                    </div>\n\
                    <div class='optionBox'>\n\
                        <div class='inputArea' ondblclick='showInput(this)'>双击输入选项</div>\n\
                        <input class='txtArea' type='text' onblur='hideInput(this, 1)'/>\n\
                        <span class='deleteOption' onclick='deleOption(this)' title='去除选项'></span>\n\
                    </div>\n\
                    <div class='optionBox'>\n\
                        <div class='inputArea' ondblclick='showInput(this)'>双击输入选项</div>\n\
                        <input class='txtArea' type='text' onblur='hideInput(this, 1)'/>\n\
                        <span class='deleteOption' onclick='deleOption(this)' title='去除选项'></span>\n\
                    </div>\n\
                    <select class='newNameClass form-select'>\n\
                      <option></option>\n\
                      <option></option>\n\
                      <option></option>\n\
                    </select>\n\
                </div>\n\
                  ";

var radioOption = "<div class='pr'>\n\
                        <input type='radio' class='newNameClass' />\n\
                        <div class='inputArea' ondblclick='showInput(this)'>双击输入选项</div>\n\
                        <input class='txtArea' type='text' onblur='hideInput(this, 1)'/>\n\
                        <span class='deleteOption' onclick='deleOption(this)' title='去除选项'></span>\n\
                    </div>";

var checkboxOption = "<div class='pr'>\n\
                        <input type='checkbox' class='newNameClass'/>\n\
                        <div class='inputArea' ondblclick='showInput(this)'>双击输入选项</div>\n\
                        <input class='txtArea' type='text' onblur='hideInput(this, 1)'/>\n\
                        <span class='deleteOption' onclick='deleOption(this)' title='去除选项'></span>\n\
                      </div>";

var selectOption = "<div class='optionBox'>\n\
                        <div class='inputArea' ondblclick='showInput(this)'>双击输入选项</div>\n\
                        <input class='txtArea' type='text' onblur='hideInput(this, 1)'/>\n\
                        <span class='deleteOption' onclick='deleOption(this)' title='去除选项'></span>\n\
                    </div>";

function changeUrl(obj, site_id, flag, page_id){
    var tf_flag;
    var content = $.trim($("#page_content").val());
    if(flag==1){
        $(obj).parents("form").attr("action", "/sites/"+ site_id + "/pages/preview").attr("target", "_blank").removeAttr("data-remote");
    }else if(flag==0){
        tf_flag = validatePageForm(content);
        $(obj).parents("form").attr("action", "/sites/"+ site_id + "/pages").attr("data-remote", "true").removeAttr("target");
    }else{
        tf_flag = validatePageForm(content);
        $(obj).parents("form").attr("action", "/sites/"+ site_id + "/pages/"+ page_id).attr("data-remote", "true").removeAttr("target");
    }
    return tf_flag;
}

//show_tag($('#micro_text'), 'auto_block', 'text')  新建关键字或者自动回复消息
function show_tag(obj, location, text_or_it){
    var tab = obj.parents(".second_box");
    var scolltop = document.body.scrollTop|document.documentElement.scrollTop;
    var win_height = document.documentElement.clientHeight;//jQuery(document).height();
    var z_layer_height = tab.height();
    tab.css('top',(win_height-z_layer_height)/2 + scolltop);
    var doc_width = $(document).width();
    var layer_width = tab.width();
    tab.css('left',(doc_width-layer_width)/2);
    obj.parent(".second_content").show();
    tab.show();
    if(text_or_it){
        obj.parent(".second_content").find(".confirm_btn").bind('click',function(){
            setChoose(obj, text_or_it == 'text' ? 1 : 0, location)
        })
    }
    $(".second_bg").show();
}

function hide_tab(obj){
    obj.parent(".second_content").hide();
    obj.parents(".second_box").hide();
    $(".second_bg").hide();
}

function addSelectOption(obj){
    var input_value = $(obj).val();
    var option_box = $(obj).parent();
    var index = option_box.parents(".selectBox").find(".optionBox").index(option_box);
    var optionFirst = $(obj).parents(".selectBox").find("select").find('option')[index];

    $(optionFirst).val(input_value);
    $(optionFirst).text(input_value);
}

function addQuestion(type){
    var newEle;
    switch(type)
    {
        case 1: //input
            $(".insertDiv").append(inputEle);
            var inputCount = $(".insertDiv").find(".inputBox").length;
            newEle = $(".insertDiv .insertBox ").last();
            newEle.find(".textQuestion").attr("name", "form[input_" + inputCount + "_value]");
            newEle.find(".newNameClass").attr("name", "form[input_" + inputCount + "]");
            break;
        case 2: //radio
            $(".insertDiv").append(radioEle);
            var radioCount = $(".insertDiv").find(".radioBox").length;
            newEle = $(".insertDiv .insertBox ").last();
            newEle.find(".textQuestion").attr("name", "form[radio_" + radioCount + "_value]");
            newEle.find(".newNameClass").attr("name", "form[radio_" + radioCount + "]");
            break;
        case 3: //checkbox
            $(".insertDiv").append(checkboxEle);
            var checkboxCount = $(".insertDiv").find(".checkboxBox").length;
            newEle = $(".insertDiv .insertBox ").last();
            newEle.find(".textQuestion").attr("name", "form[checkbox_" + checkboxCount + "_value]");
            newEle.find(".newNameClass").attr("name", "form[checkbox_" + checkboxCount + "][]");
            break;
        case 4:  //select
            $(".insertDiv").append(selectEle);
            var selectCount = $(".insertDiv").find(".selectBox").length;
            newEle = $(".insertDiv .insertBox ").last();
            newEle.find(".textQuestion").attr("name", "form[select_" + selectCount + "_value]");
            newEle.find(".newNameClass").attr("name", "form[select_" + selectCount + "]");
            break;
        default:
            $(".insertDiv").append(inputEle);
    }
}

//双击div， 显示input
function showInput(obj){
    var value = $(obj).text() == "双击输入选项" || $(obj).text() == "双击输入问题" || $(obj).text() == "双击输入问题或选项"? "" : $(obj).text()
    $(obj).hide();
    $(obj).parent().children(".txtArea").val(value).show();
    $(obj).parent().children(".txtArea").focus();
}

//双击div，修改后blur隐藏当前输入框
function hideInput(obj, flag){
    var input_value = $(obj).val();
    //判断内容是否罕有非法字符
    if($.trim(input_value) == "" || pattern.test(input_value)){
        tishi_alert("请输入内容，不能包含非法字符")
    }else{
        $(obj).hide();
        if(flag == 1){
            var radio = $(obj).parent().find("input[type='radio']");
            if(radio){
                radio.val(input_value);
            }
            var checkbox = $(obj).parent().find("input[type='checkbox']");
            if(checkbox){
                checkbox.val(input_value);
            }
            if($(obj).parent().hasClass("optionBox")){
                addSelectOption(obj);
            }
        }
        $(obj).parent().children(".inputArea").text($.trim(input_value)=="" ? "双击输入问题或选项" : input_value).show();
    }
}

//提交表单验证 #TODO非空验证
function submitForm(obj, flag,id){
    var content = $.trim($(".insertDiv").html());
    var tf_flag = validatePageForm(content);
    content = content.replace(/;/g, "");  //把分号替换掉，否则表单提交不完全，会被分号隔开
    var title = $.trim($("#page_title").val()); //拿到去空格的值
    var file_name = $.trim($("#page_file_name").val());
    var img=$("#page_img_path").val();
    img=$.trim(img);
    if(img==""){
        tishi_alert('请拖入图片');
        return false;
    }
    $("#page_title")[0].value=title;    //将去空格的值赋回去
    $("#page_file_name")[0].value=file_name;
    
    if(tf_flag){
        if(flag=="submit"){ //新建 或者编辑
            var dataValue;
            $("#form_container form").removeAttr("target");
            $("#form_container #hiddenContent").remove();
            dataValue = $(obj).parents("form").serialize();
            dataValue = dataValue + "&page[content]=" + content+"&page[img_path]="+img;
            $.ajax({
                url: $(obj).attr("alt"),
                type: "POST",
                dataType: "script",
                data:dataValue,
                success:function(data){

                //保存成功
                // change_status(site_id,1,"");
                },
                error:function(data){
                //alert("error")
                }
            })
        }else{ //预览
            //img="<img src='"+img+"'/><br/>";
            $("#form_container #hiddenContentContainer").html('<input type="hidden" id="hiddenContent" name="page[content]"/>');
            $("#form_container form").attr("target", "_blank").attr("action", $(obj).attr("alt"));
            $("#form_container #hiddenContent").val(content);
            $("#form_container form").submit();
        }
    }
    
}

//增加选项
function addOption(obj, flag){
    if(flag==2){ //radio
        $(obj).parents(".radioBox").append(radioOption);
        var label_radio = $(obj).parents(".radioBox").find(".textQuestion").first();
        var last_radio = $(obj).parents(".radioBox").find(".newNameClass").last();
        last_radio.attr("name", label_radio.attr("name").replace("_value", ""));
    }else if(flag == 3){ //checkbox
        $(obj).parents(".checkboxBox").append(checkboxOption);
        var label_checkbox = $(obj).parents(".checkboxBox").find(".textQuestion").first();
        var last_checkbox = $(obj).parents(".checkboxBox").find(".newNameClass").last();
        last_checkbox.attr("name", label_checkbox.attr("name").replace("_value", "") + "[]");
    }else if(flag == 4){ //select
        $(obj).parents(".selectBox").find(".optionBox").last().after(selectOption);
        $(obj).parents(".selectBox").find("select").append("<option></option>")
    }
}

//删除选项
function deleOption(obj){
    if(confirm('确定移除吗？')){
        if($(obj).parent().hasClass("optionBox")){
            var option_box = $(obj).parent();
            var index = option_box.parents(".selectBox").find(".optionBox").index(option_box);
            var optionFirst = $(obj).parents(".selectBox").find("select").find('option')[index];
            $(optionFirst).remove();
        }
        $(obj).parent().remove();
    }  
}

function validatePageForm(content)
{
    var title = $.trim($("#page_title").val());
    var file_name = $.trim($("#page_file_name").val());
    var tf_flag = true;
    if(title == ""){
        tishi_alert("请输入标题");
        tf_flag = false;
    }else if(file_name == "" || (file_name !="style.css" && patten_html.test(file_name))){
        tishi_alert("请输入文件名，不能包含'.'");
        tf_flag = false;
    }else if(content == ""){
        tishi_alert("请输入内容");
        tf_flag = false;
    }
    
    
    $("#page_title")[0].value=title;    //将去空格的值赋回去
    $("#page_file_name")[0].value=file_name;
    
    return tf_flag;
}

function checkITValid(obj){
    var title = $.trim($("#image_text_container #image_text_title").val());
    var file_name = $.trim($("#image_text_container #image_text_file_name").val());
    var tf_flag = true;
    if(title == ""){
        tishi_alert("请输入标题");
        tf_flag = false;
    }else if(file_name == "" || (file_name !="style.css" && patten_html.test(file_name))){
        tishi_alert("请输入文件名，不能包含'.'");
        tf_flag = false;
    }
    return tf_flag;
}