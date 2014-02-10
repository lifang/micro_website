// image preview function, demonstrating the ui.dialog used as a modal window
var tuwenBlock = "<div class=\"tuwenBox\">\n\
                    <span class=\"close\"  onclick=\"deleOption(this)\"></span>\n\
                    <div class=\"tuwenImg\"></div>\n\
                    <input type=\"hidden\" name=\"image_text[img_path][]\" class=\"image_text_input\"/>\n\
                    <textarea class=\"it_content\" name=\"image_text[content][]\"></textarea>\n\
                  </div>"

$(function(){

    })


function viewLargerImage( obj ) {
    var src = $(obj).attr( "src" );
    var title = $(obj).attr( "alt" );
    var img = "<img class='big-image' src='" + src +"' alt='"+ title+"'/>";
    $( "#viewLarge" ).html(img);
    setTimeout(function() {
        $( "#viewLarge" ).dialog({
            title: title,
            height: 800,
            width: 1000,
            modal: true
        });
    }, 1 );
}

function it_drop(obj){
    obj.droppable({
        accept: ".picRes > .picBox",
        activeClass: "ui-state-highlight",
        drop: function( event, ui ) {
           
            var parent =$(this).parent().attr("class");
            
            if(parent == 'homeBg'){
                $(this).next().html('<img src=' + '\'' +ui.draggable.find("img").attr("src") +'\'' + ' />');
                $(this).html("");
                $(this).parent().find("input")[0].value= ui.draggable.find("img").attr("src");
                var img=$(this).next().find("img");
                $(img).css({
                    "width": "320px",
                    "height": "568px"
                });
            }else if(parent == 'model1'){
                var img1=ui.draggable.find("img");
                var width_or_height = setImageWH(img1, 93, 93);
                $(this).html('<img src=' + '\'' +ui.draggable.find("img").attr("src") +'\'' +width_or_height+ ' />');
                $(this).parent().find("input")[0].value= ui.draggable.find("img").attr("src");
            /* var imgWidth1 = $(img1).width();
                var imgHeight1 = $(img1).height();
                if(imgWidth1 > imgHeight1){
                    $(img1).css({
                        "width": "93px",
                        "height": "auto"
                    });
                }else{
                    $(img1).css({
                        "height": "93px",
                        "width" : "auto"
                    });
                }*/
            }else if(parent == 'model2'){

                var img1=ui.draggable.find("img");
                var width_or_height = setImageWH(img1, 77, 77);
                $(this).html('<img src=' + '\'' +ui.draggable.find("img").attr("src") +'\'' + width_or_height+'  />');
                
            }else if(parent == 'smlPic'){
                var img1=ui.draggable.find("img");
                var width_or_height = setImageWH(img1, 145, 145);
                $(this).html('<img src="' +ui.draggable.find("img").attr("src") +'" '+width_or_height+'/>');
                
                
            }else if($(this).attr("class") == 'topPic ui-droppable'){
                $(this).html('<img src="' +ui.draggable.find("img").attr("src") +'"/> '+'<input type="hidden" name="top_img" value="'+ui.draggable.find("img").attr("src")+'">');
                var img1=$(this).find("img");
                var imgWidth1 = $(img1).width();
                var imgHeight1 = $(img1).height();
                $(img1).css({
                    "width": "320px",
                    "height": "150px"
                });
            //                if(imgWidth1 > imgHeight1){
            //                    $(img1).css({
            //                        "width": "320px",
            //                        "height": "auto"
            //                    });
            //                }else{
            //                    $(img1).css({
            //                        "height": "150px",
            //                        "width" : "auto"
            //                    });
            //                }
            }
            
            //$(this).attr("src", ui.draggable.find("img").attr("src"));
            $(this).next().val(ui.draggable.find("img").attr("src"));
        }
    });
}

function temp_it_drop(obj, width, height){
    obj.droppable({
        accept: ".picRes > .picBox",
        activeClass: "ui-state-highlight",
        drop: function( event, ui ) {
            var img = ui.draggable.find("img");
            var width_or_height = setImageWH(img, width, height);
            var img_src = img.attr("src");
            $(this).text(" ");
            $(this).parent("li").find("input.img_src").val(img_src);
            $(this).html('<img src=' + '\'' +img_src +'\'' + width_or_height + ' />');
        }
    });
};

function temp_it_drop_slide(obj, width, height){
    obj.droppable({
        accept: ".picRes > .picBox",
        activeClass: "ui-state-highlight",
        drop: function( event, ui ) {
            var img = ui.draggable.find("img");
            var width_or_height = "width=" + width + " height=" + height;
            var img_src = img.attr("src");
            $(this).text(" ");
            $(this).parent("li").find("input.img_src").val(img_src);
            $(this).html('<img src=' + '\'' +img_src +'\'' + width_or_height + ' />');
        }
    });
};

function form_it_drop(obj, width, height){
    obj.droppable({
        accept: ".picRes > .picBox",
        activeClass: "ui-state-highlight",
        drop: function( event, ui ) {
            var img = ui.draggable.find("img");
            // var width_or_height = setImageWH(img, width, height);
            var img_src = img.attr("src");
            $(this).html('<img src=' + '\'' +img_src +'\'' +' width='+ width + ' height=' + height +' />');
            $(this).next().val(img_src);
        }
    });
}

function setImageWH(img, width, height){
    var imgWidth = $(img).width();
    var imgHeight = $(img).height();
    var i = width/height;
    var j = imgWidth/imgHeight;
    if(j>=i){
        return "width=" + (imgWidth >= width ? width : imgWidth);
    }else{
        return "height=" + (imgHeight >= height ? height : imgHeight);
    }
}

function it_drag(obj){
    obj.draggable({
        cancel: "a.ui-icon", // clicking an icon won't initiate dragging
        revert: "invalid", // when not dropped, the item will revert back to its initial position
        containment: "document",
        helper: "clone",
        cursor: "move"
    });
}

function appendEditor(){
    $(".image_text_area").append(tuwenBlock);
    KindEditor.create($(".it_content").last(), {
        resizeMode : 1,
        width : "300px",
        items : ['source',
        'fontname', 'fontsize', '|', 'forecolor', 'hilitecolor', 'bold', 'italic', 'underline',
        'removeformat', '|', 'justifyleft', 'justifycenter', 'justifyright', 'insertorderedlist',
        'insertunorderedlist']
    });

    //drop 元素
    form_it_drop($(".tuwenImg").last(), 320, 150);
}

function imageTextSetKey(obj){
    var address = $("#one_key_button .address").val();
    if($.trim(address) != ""){
        $(".onekey_address").val(address);
    }
    var phone = $("#one_key_button .phone").val();
    if($.trim(phone) != ""){
        $(".onekey_phone").val(phone);
    }
    var checked = $("#one_key_button input[name=form_id]:checked");
    var form_id = checked.length > 0 ? checked.val() : "";
    $(".onekey_form_id").val(form_id);
    if(form_id != ""){
        var form_name = checked.next().text();
        $(".onekey_form_name").val(form_name);
    }else{
        $(".onekey_form_name").val("");
    }
    hide_tab($("#one_key_button"))
    
}