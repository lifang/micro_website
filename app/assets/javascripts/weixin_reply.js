/* 
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

function showMask(obj){
    $(obj).find(".appmsg_mask").show();
}

function hideMask(obj){
    if($(obj).find(".icon_appmsg_selected").css("display") == "none")
    {
        $(obj).find(".appmsg_mask").hide();
    }
//  $(obj).find(".icon_appmsg_selected").hide();
}

function selectBox(obj){
    $("#micro_image_text").find(".msgBox").removeClass("selected");
    $("#micro_image_text").find(".msgBox .appmsg_mask").hide();
    $("#micro_image_text").find(".msgBox .icon_appmsg_selected").hide();
    $(obj).find(".appmsg_mask").show();
    $(obj).find(".icon_appmsg_selected").show();
    $(obj).addClass("selected")
}


function setChoose(obj, flag){
    var html;
    if(flag == 0){
        var selectBlock = obj.find(".selected");
        html = selectBlock.parent().html();
        $(".auto_message").html(html);
        $(".auto_message").find(".appmsg_mask").remove();
        $(".auto_message").find(".icon_appmsg_selected").remove();
    }else{
        html = obj.find(".micro_text").val();
        $(".auto_message").html(html);
    }

    hide_tab(obj);
}