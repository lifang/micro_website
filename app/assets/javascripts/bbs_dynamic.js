/* 
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
function seeMorePost(obj){
    //var post_total = $(obj).attr("data-page-total");
    //var page = $(obj).attr("data-page");
    $.ajax({
        url: $(obj).attr("data-url"),
        type: "GET",
        dataType: "html",
        success:function(data){   
            $(".bbs_dropDown").remove();
            $(".bbs-a").last().after(data);
        },
        error:function(data){
            alert("error");
        }
    })
}

function seeMoreComment(obj){
    $.ajax({
        url: $(obj).attr("data-url"),
        type: "GET",
        dataType: "html",
        success:function(data){
            $(".bbs_clickDown").remove();
            $(".bbs_messBox").last().after(data);
        },
        error:function(data){
            alert("error");
        }
    })
}

function replyComment(num){
    $( "#dialog-reply-form" ).find("#target_person").val(num);
    $( "#dialog-reply-form" ).prev().text("回复" + num + "楼");
    $( "#reply_content" ).val("");
    show_tag($("#dialog-reply-form"));

}

function checkLength( o, max ) {
    if($.trim(o.val()) == ""){
        tishi_alert( "回复内容不能为空." );
        return false;
    }
    else if ( o.val().length > max ) {
        o.addClass( "ui-state-error" );
        tishi_alert( "回复内容不能超过" + max + "." );
        return false;
    } else {
        return true;
    }
}

function toggleStar(obj){
    var flag;
    if($(obj).hasClass("bbs_star_none")){
        $(obj).addClass("bbs_star_good");
        $(obj).removeClass("bbs_star_none");
        flag = 1;
    }else{
        $(obj).addClass("bbs_star_none");
        $(obj).removeClass("bbs_star_good");
        flag = 0;
    }
    $.ajax({
        async:true,
        url: $(obj).attr("data-url"),
        type: "GET",
        dataType: "text",
        data:{
            flag : flag
        },
        success:function(data){
        //alert(data);
        },
        error:function(data){
            alert("error");
        }
    })
}

function checkText(obj){
    var content = $(obj).parents("form").find("#comment_reply_content");
    if($.trim(content.val()) == ""){
        tishi_alert( "回复内容不能为空." );
        return false;
    }
    else if ( content.val().length > 50 ) {
        
        tishi_alert( "回复内容不能超过" + 50 + "." );
        return false;
    } else {
        return true;
    }
}

function checkDialogText(obj){
    var name = $( "#reply_content" );
    var bValid = true;
    bValid = bValid && checkLength( name, 50 );
    return bValid;
}