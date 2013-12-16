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
            $(".bbs_list").last().after(data);
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
    var name = $( "#reply_content" );
    $("#dialog-reply-form").dialog({
        autoOpen: false,
        height: 300,
        width: 300,
        modal: true,
        title: "回复" + num + "楼",
        buttons: {
            "回复": function() {
                var bValid = true;
                bValid = bValid && checkLength( name, 50 );
                if(bValid){
                    $( "#dialog-reply-form" ).find("#target_person").val(num);
                    $("#dialog-reply-form").find("form").submit();
                    $( this ).dialog( "close" );
                }
            },
            "取消": function() {
                $( this ).dialog( "close" );
            }
        },
        close: function() {
            name.val( "" ).removeClass( "ui-state-error" );
        }
    });
    $( "#dialog-reply-form" ).dialog( "open" );
}

function checkLength( o, max ) {
    if($.trim(o.val()) == ""){
       updateTips( "回复内容不能为空." );
    }
    else if ( o.val().length > max ) {
        o.addClass( "ui-state-error" );
        updateTips( "回复内容不能超过" + max + "." );
        return false;
    } else {
        return true;
    }
}

function updateTips( t ) {
    var tips = $( ".validateTips" );
    tips
    .text( t )
    .addClass( "ui-state-highlight" );
    setTimeout(function() {
        tips.removeClass( "ui-state-highlight", 1500 );
    }, 500 );
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
        url: $(obj).attr("data-url"),
        type: "POST",
        dataType: "text",
        data:{flag : flag},
        success:function(data){
           //alert(data);
        },
        error:function(data){
            alert("error");
        }
    })
}