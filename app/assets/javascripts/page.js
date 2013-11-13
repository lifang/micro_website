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

