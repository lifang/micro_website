// JavaScript Document
//bbs
$(function(){
	/*var winWidth=0;
	if (window.innerWidth) {
     	winWidth = window.innerWidth; 
	}else if ((document.body) && (document.body.clientWidth)) {
		winWidth = document.body.clientWidth; 
	};
    if (document.documentElement && document.documentElement.clientWidth) {  
		winWidth = document.documentElement.clientWidth; 
	} */
	var winWidth = document.documentElement.clientWidth;

	$(".bbs_title").css("width",winWidth+17);
	$(".bbs_title img").css("width",winWidth+17);
})

//bbs详细点击 赞
$(function(){
	$(".bbs_title_good").click(function(){
		$(this).addClass("bbs_title_good00");	
	});	
})

function delete_post(site,post){
     if(confirm('确定删除？'))
     window.location.href="/delete_post?site_id="+site+"&id="+post;
}
function to_top(site,post){
    if(confirm('确定置顶？'))
     window.location.href="/top?site_id="+site+"&id="+post;
}
function unto_top(site,post){
    if(confirm('确定取消置顶？'))
     window.location.href="/untop?site_id="+site+"&id="+post;
}
function show_post_info(id,title,content,img){
    $("#post_title").val(title);
    $("#post_img").attr("src",img);
    $("#post_id").val(id);
    $("#post_content").text(content);

     $(".second_bg").show();
     $(".second_box.theme_edt").show();
}

function cancle_post_edit(){
    $(".second_bg").hide();
    $(".second_box.theme_edt").hide();
    $(".second_box.new_theme").hide();
    $(".second_box.wp").hide();
}

