/* 
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
//flag=0 submit form, flag=1 preview
function changeUrl(obj, site_id, flag, page_id){
    if(flag==1){
        $(obj).parents("form").attr("action", "/sites/"+ site_id + "/pages/preview").attr("target", "_blank");
    }else if(flag==0){
        $(obj).parents("form").attr("action", "/sites/"+ site_id + "/pages").removeAttr("target");
    }else{
        $(obj).parents("form").attr("action", "/sites/"+ site_id + "/pages/"+ page_id).removeAttr("target");
    }
    
    
}

