// image preview function, demonstrating the ui.dialog used as a modal window

function viewLargerImage( obj ) {
    var src = $(obj).attr( "data-path-name" );
    var title = $(obj).attr( "alt" );
    var img = "<img class='big-image' src='" + src +"' alt='"+ title+"'/>";
    $( "#viewLarge" ).html(img);
    setTimeout(function() {
        $( "#viewLarge" ).dialog({
            title: title,
            width: 630,
            modal: true
        });
    }, 1 );
}

