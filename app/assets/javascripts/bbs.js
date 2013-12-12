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