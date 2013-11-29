// image preview function, demonstrating the ui.dialog used as a modal window

function viewLargerImage( obj ) {
    var src = $(obj).attr( "src" );
    var title = $(obj).attr( "alt" );
    var img = "<img src='" + src +"' alt='"+ title+"' width='600' height='500'/>";
    $( "#viewLarge" ).html(img);
    setTimeout(function() {
        $( "#viewLarge" ).dialog({
            title: title,
            width: 630,
            modal: true
        });
    }, 1 );
}