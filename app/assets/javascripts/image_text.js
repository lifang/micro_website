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
        accept: ".picRes > li",
        activeClass: "ui-state-highlight",
        drop: function( event, ui ) {
            $(this).attr("src", ui.draggable.find("img").attr("src"));
            $(this).next().val(ui.draggable.find("img").attr("src"));
        },
        activate: function( event, ui ) {
            var img = ui.draggable.find("img");
            var imgWidth = $(img).width();
            var imgHeight = $(img).height();

            if(imgWidth > imgHeight){
                $(this).css({
                    "width": "300px",
                    "height": "auto"
                });
            }else{
                $(this).css({
                    "height": "195px",
                    "width" : "auto"
                });
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
        items : [
        'fontname', 'fontsize', '|', 'forecolor', 'hilitecolor', 'bold', 'italic', 'underline',
        'removeformat', '|', 'justifyleft', 'justifycenter', 'justifyright', 'insertorderedlist',
        'insertunorderedlist']
    });

    //drop 元素
    it_drop($( ".image_area img" ).last());
}