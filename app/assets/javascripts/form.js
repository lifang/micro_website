/* 
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
function submit_form(obj){
    var flag = true;
    $(obj).parents(".submit_form_static").find('.questionTitle').each(function(){
        var title = $(this).text();
        var insert = $(this).parents(".insertBox");
        var type = insert.find("input.newNameClass");

        if(type.attr('type')=="text"){
            if($.trim(type.val()) == ""){
                tishi_alert(title + " 不能为空！");
                flag = false;
                //return false;
            }else{
                flag = true;
            }
        }else{
            if(insert.find("input:checked").length == 0){
                tishi_alert(title + " 不能为空！");
                flag = false;
                //return false;
            }else{
                flag = true;
            }
        }
    });
    if(flag){
        $(obj).parents(".submit_form_static").submit();
    }
}

