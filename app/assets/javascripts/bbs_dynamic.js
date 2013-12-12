/* 
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
$(function(){
    $(".bbs_dropDown").click(function(){
        $.ajax({
            url: $(this).attr("data-url"),
            type: "GET",
            dataType: "html",
            data:{},
            success:function(data){
              $(".bbs_list").after(data)
            },
            error:function(data){
                alert("error")
            }
        })
    })
    
})

