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


