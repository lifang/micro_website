// image preview function, demonstrating the ui.dialog used as a modal window

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
           
            var parent =$(this).parent().attr("class")
            if(parent == 'homeBg'){
                $(this).next().html("<img src="+ui.draggable.find("img").attr("src")+" />");
                $(this).html("");
                var img=$(this).next().find("img");
                $(img).css({
                    "width": "320px",
                    "height": "568px"
                });
            }else if(parent == 'model1'){

                $(this).html("<img src="+ui.draggable.find("img").attr("src")+" />");
                var img1=$(this).find("img");
                var imgWidth1 = $(img1).width();
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
                }
            }else if(parent == 'model2'){

                $(this).html("<img src="+ui.draggable.find("img").attr("src")+" />");
                var img1=$(this).find("img");
                var imgWidth1 = $(img1).width();
                var imgHeight1 = $(img1).height();
                if(imgWidth1 > imgHeight1){
                    $(img1).css({
                        "width": "77px",
                        "height": "auto"
                    });
                }else{
                    $(img1).css({
                        "height": "77px",
                        "width" : "auto"
                    });
                }
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
            var img_src = ui.draggable.find("img").attr("src");
            $(this).text(" ");
            $(this).parent("li").find("input.img_src").val(img_src);
            $(this).html("<img src="+img_src+" />");
            var img = $(this).find("img");
            var imgWidth = $(img).width();
            var imgHeight = $(img).height();
            if(imgWidth > imgHeight){
                $(img).css({ "width": width + "px" });
            }else{
                $(img).css({ "height": height + "px" });
            }
        }
    });
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
    $(".it_editor").last().append(ediotrContent);
    KindEditor.create($(".it_content").last(), {
        resizeMode : 1,
        width : "400px",
        items : ['source',
        'fontname', 'fontsize', '|', 'forecolor', 'hilitecolor', 'bold', 'italic', 'underline',
        'removeformat', '|', 'justifyleft', 'justifycenter', 'justifyright', 'insertorderedlist',
        'insertunorderedlist']
    });

    //drop 元素
    it_drop($( ".image_area img" ).last());
}