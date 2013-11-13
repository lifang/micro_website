/* 
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
//flag=0 submit form, flag=1 preview
function changeUrl(obj, site_id, flag, page_id){
    if(flag==1){
        $(obj).parents("form").attr("action", "/sites/"+ site_id + "/pages/preview").attr("target", "_blank").removeAttr("data-remote");
    }else if(flag==0){
        $(obj).parents("form").attr("action", "/sites/"+ site_id + "/pages").attr("data-remote", "true").removeAttr("target");
    }else{
        $(obj).parents("form").attr("action", "/sites/"+ site_id + "/pages/"+ page_id).attr("data-remote", "true").removeAttr("target");
    } 
}

function show_tag(obj){
    obj.parent(".second_content").show();
    obj.parents(".second_box").show();
    $(".second_bg").show();
}
function hide_tab(obj){
    obj.parent(".second_content").hide();
    obj.parents(".second_box").hide();
    $(".second_bg").hide();
}

var inputEle = "<div class='insertBox inputBox'><span class='delete' onclick='deleOption(this)'></span><div class='inputArea' ondblclick='showInput(this)'>双击输入问题</div><input class='txtArea textQuestion' type='text' onblur='hideInput(this)' /><input type='text' class='newNameClass' /></div>";

var radioEle = "<div class='insertBox radioBox'><span class='delete' onclick='deleOption(this)'></span><span class='add_option' onclick='addOption(this, 2)'>添加选项</span><div class='inputArea' ondblclick='showInput(this)'>双击输入问题</div><input class='txtArea textQuestion' type='text' onblur='hideInput(this)' /><div><input type='radio' class='newNameClass' /><div class='inputArea' ondblclick='showInput(this)'>双击输入选项</div><input class='txtArea' type='text' onblur='hideInput(this)'/><span class='deleteOption' onclick='deleOption(this)'>去除选项</span></div><div><input type='radio' class='newNameClass' /><div class='inputArea' ondblclick='showInput(this)'>双击输入选项</div><input class='txtArea' type='text' onblur='hideInput(this)'/><span class='deleteOption' onclick='deleOption(this)'>去除选项</span></div></div>";

var checkboxEle = "<div class='insertBox checkboxBox'><span class='delete' onclick='deleOption(this)'></span><span class='add_option' onclick='addOption(this, 3)'>添加选项</span><div class='inputArea' ondblclick='showInput(this)'>双击输入问题</div><input class='txtArea textQuestion' type='text' onblur='hideInput(this)'/><div><input type='checkbox' class='newNameClass'/><div class='inputArea' ondblclick='showInput(this)'>双击输入选项</div><input class='txtArea' type='text' onblur='hideInput(this)'/><span class='deleteOption' onclick='deleOption(this)'>去除选项</span></div><div><input type='checkbox' class='newNameClass'/><div class='inputArea' ondblclick='showInput(this)'>双击输入选项</div><input class='txtArea' type='text' onblur='hideInput(this)'/><span class='deleteOption' onclick='deleOption(this)'>去除选项</span></div></div>";

var radioOption = "<div><input type='radio' class='newNameClass' /><div class='inputArea' ondblclick='showInput(this)'>双击输入选项</div><input class='txtArea' type='text' onblur='hideInput(this)'/><span class='deleteOption' onclick='deleOption(this)'>去除选项</span></div>";

var checkboxOption = "<div><input type='checkbox' class='newNameClass'/><div class='inputArea' ondblclick='showInput(this)'>双击输入选项</div><input class='txtArea' type='text' onblur='hideInput(this)'/><span class='deleteOption' onclick='deleOption(this)'>去除选项</span></div>";

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
            newEle.find(".newNameClass").attr("name", "form[checkbox_" + checkboxCount + "]");
            break;
        default:
            $(".insertDiv").append(inputEle);
    }
}

//双击div， 显示input
function showInput(obj){
    var value = $(obj).text() == "双击输入选项" || $(obj).text() == "双击输入问题" ? "" : $(obj).text()
    $(obj).hide();
    $(obj).parent().children(".txtArea").val(value).show();
    $(obj).parent().children(".txtArea").focus();
}

//双击div，修改后隐藏当前输入框
function hideInput(obj){
    $(obj).hide();
    var radio = $(obj).parent().find("input[type='radio']");
    if(radio){
        radio.val($(obj).val());
    }
    var checkbox = $(obj).parent().find("input[type='checkbox']");
    if(checkbox){
        checkbox.val($(obj).val());
    }
    $(obj).parent().children(".inputArea").text($(obj).val()).show();
}

//提交表单验证 #TODO非空验证
function submitForm(obj, flag){
    var content = $.trim($(".insertDiv").html());
    content = content.replace(/;/g, "");  //把分号替换掉，否则表单提交不完全，会被分号隔开
    if(flag=="submit"){ //新建 或者编辑
        var dataValue;
        $("#form_container form").removeAttr("target");
        $("#form_container #hiddenContent").remove();
        dataValue = $(obj).parents("form").serialize();
        dataValue = dataValue + "&page[content]=" + content;
        $.ajax({
            url: $(obj).attr("alt"),
            type: "POST",
            dataType: "script",
            data:dataValue,
            success:function(data){
            //alert("success")
            },
            error:function(data){
            //alert("error")
            }
        })
    }else{ //预览
        $("#form_container #hiddenContentContainer").html('<input type="hidden" id="hiddenContent" name="page[content]"/>');
        $("#form_container form").attr("target", "_blank").attr("action", $(obj).attr("alt"));
        $("#form_container #hiddenContent").val(content);
        $("#form_container form").submit();
    }
    
}

//增加选项
function addOption(obj, flag){
    if(flag==2){ //radio
        $(obj).parents(".radioBox").append(radioOption);
    }else{ //checkbox
        $(obj).parents(".checkboxBox").append(checkboxOption);
    }
}

//删除选项
function deleOption(obj){
    $(obj).parent().remove();
}