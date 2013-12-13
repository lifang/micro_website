/* 
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
function seeMore(obj){
    var post_total = $(obj).attr("data-page-total");
    var page = $(obj).attr("data-page");
    $.ajax({
        url: $(obj).attr("data-url"),
        type: "GET",
        dataType: "html",
        success:function(data){
            alert(data)
            $(".bbs_dropDown").remove();
            alert(1)
            $(".bbs_list").last().after(data);
            if(post_total <= page * 3){
                alert(2)
                $(".bbs_dropDown").remove();
            }
        },
        error:function(data){
            alert("error");
        }
    })
}


