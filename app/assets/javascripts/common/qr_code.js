/* 
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

function submit_qrcode(obj){
   var flag = validatePageForm("hello");
   if(flag){
       if($("#page_img_path").val()==""){
           tishi_alert("请拖入背景图片!");
           return false;
       }
   }else{
       return false;
   }
}


function qr_code_drop(obj, width, height){
    obj.droppable({
        accept: ".picRes > .picBox",
        activeClass: "ui-state-highlight",
        drop: function( event, ui ) {
            var img = ui.draggable.find("img");
            var img_src = img.attr("src");
            $(this).css({"background-image":'url(' + '\'' +img_src + '\')', 'background-size':'cover'});
            $(this).next().val(img_src);
        }
    });
}