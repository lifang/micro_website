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

var inputEle = "<div class='insertBox inputBox'><span class='delete'></span><div class='inputArea' ondblclick='showInput(this)'>双击输入问题</div><input class='txtArea textQuestion' type='text' onblur='hideInput(this)' /><input type='text' class='newNameClass' /></div>";

var radioEle = "<div class='insertBox radioBox'><span class='delete'></span><div class='inputArea' ondblclick='showInput(this)'>双击输入问题</div><input class='txtArea textQuestion' type='text' onblur='hideInput(this)' /><div><input type='radio' class='newNameClass' /><div class='inputArea' ondblclick='showInput(this)'>双击输入选项</div><input class='txtArea' type='text' onblur='hideInput(this)'/></div><div><input type='radio' class='newNameClass' /><div class='inputArea' ondblclick='showInput(this)'>双击输入选项</div><input class='txtArea' type='text' onblur='hideInput(this)'/></div></div>";

var checkboxEle = "<div class='insertBox checkboxBox'><span class='delete'></span><div class='inputArea' ondblclick='showInput(this)'>双击输入问题</div><input class='txtArea textQuestion' type='text' onblur='hideInput(this)'/><div><input type='checkbox' class='newNameClass'/><div class='inputArea' ondblclick='showInput(this)'>双击输入选项</div><input class='txtArea' type='text' onblur='hideInput(this)'/></div><div><input type='checkbox' class='newNameClass'/><div class='inputArea' ondblclick='showInput(this)'>双击输入选项</div><input class='txtArea' type='text' onblur='hideInput(this)'/></div></div>";

var radioOption = "<div><input type='radio' /><div class='inputArea' ondblclick='showInput(this)'>双击输入选项</div><input class='txtArea' type='text' onblur='hideInput(this)'/></div>";

var checkboxOption = "<div><input type='checkbox' /><div class='inputArea' ondblclick='showInput(this)'>双击输入选项</div><input class='txtArea' type='text' onblur='hideInput(this)'/></div>";

function addQuestion(type){
    var newEle;
    switch(type)
    {
        case 1:

            $(".insertDiv").append(inputEle);
            var inputCount = $(".insertDiv").find(".inputBox").length;
            newEle = $(".insertDiv .insertBox ").last();

            newEle.find(".textQuestion").attr("name", "form[input_" + inputCount + "_value]");
            newEle.find(".newNameClass").attr("name", "form[input_" + inputCount + "]");
            break;
        case 2:

            $(".insertDiv").append(radioEle);
            var radioCount = $(".insertDiv").find(".radioBox").length;

            newEle = $(".insertDiv .insertBox ").last();
            newEle.find(".textQuestion").attr("name", "form[radio_" + radioCount + "_value]");
            newEle.find(".newNameClass").attr("name", "form[radio_" + radioCount + "]");
            break;
        case 3:

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

function showInput(obj){
    $(obj).hide();
    $(obj).parent().children(".txtArea").val($(obj).text()).show();
    $(obj).parent().children(".txtArea").focus();
}

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

function submitForm(obj, flag){
    var content = $(".insertDiv").html();
    var data;
    content = content.replace(/;/g, "");
    if(flag=="new"){
        data = $(obj).parents("form").serialize();
        data = data + "&page[content]=" + content;
    }else if(flag=="edit"){
        data = $(obj).parents("form").serialize();
        "<form"
    }
    else{
        data = "page[content]=" + content;
    }
    $.ajax({
         url: $(obj).attr("alt"),
         type: "POST",
         dataType: "script",
         data:data,
         success:function(data){
             alert("success")
         },
         error:function(data){
            alert("error")
         }
     })
}