/* 
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

function changeUrl(obj, site_id){
    $(obj).parents("#main_page_form").attr("action", "/sites/"+ site_id + "/pages/preview").attr("target", "_blank")
    
}

