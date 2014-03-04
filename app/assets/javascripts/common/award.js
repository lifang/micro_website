function add_award_item(){
	var award=$(".award_item");
	var li =$("<li></li>");
	li.html("奖项名：<input type='text' name='name[]'> 奖项内容：  <input type='text' name='content[]'>奖项数：<input type='text' name='number[]'><span class='close' title='删除该奖项' onclick='remove_award_item(this)'></span> ");
	award.append(li);
}
function add_qr_code_award_item(){
	var award=$(".award_item");
	var li =$("<li></li>");
	li.html("奖项名：<input type='text' name='name[]'> 奖项内容：  <input type='file' name='content[]'>奖项数：<input type='text' name='number[]'><span class='close' title='删除该奖项' onclick='remove_award_item(this)'></span> ");
	award.append(li);
}
function remove_award_item(lii){
	var ul=$(".award_item");
//	var li=$(".award_item >li");
        var li=$(lii).parent();

	var id=$(li).find('.award_item_id').val();
	if(id!=null){
		ul.prepend($("<input type='hidden' name='remove_id[]' value='"+id+"'>"));
	}
	$(li).remove();
}
function cancle_award_page(){
	$(".second_bg").hide();
	$(".second_box.addGgl").hide();
        $(".second_box.resInfo").hide();
}
function check_award_form(){
	var name=$("input[name='name[]']");
	var content=$("input[name='content[]']");
	var number=$("input[name='number[]']");
	if(name.length==0){
		tishi_alert("奖项设置不能为空！");
		    return false;
	}
	for(var i=0;i<name.length ; i++){
		if($.trim($(name[i]).val())==""){
			tishi_alert("奖项名称存在空白！");
		    return false;
		}
		if( $.trim($(content[i]).val())==""){
			tishi_alert("奖项内容存在空白！");
		    return false;
		}
		if( !$(number[i]).val().match(/[0-9]/)){
			tishi_alert("奖项数不为空且为数字！");
		    return false;
		}
	}
	if($.trim($("#award_name").val())==""){
		tishi_alert("抽奖名称不能为空！");
		return false;
	}
	var date1=$("#datepicker").val();
	var date2=$("#datepicker1").val();
	if(date1==""||date2==""){
		tishi_alert("日期不能为空！");
		return false;
	}
	var num=$("#award_total_number").val();
	if( !num.match(/[0-9]/)){
		tishi_alert("奖券数不能为空！并且为数字");
		return false;
	}
    $(".second_content.second_content2 form").submit();
}

function award_template_drop(obj){
    obj.droppable({
        accept: ".picRes > .picBox",
        activeClass: "ui-state-highlight",
        drop: function( event, ui ) {
            var img = ui.draggable.find("img");
            var width_or_height = "width=" + $(img).width() + " height=" + $(img).height();
            var img_src = img.attr("src");
            $(this).find("input[type=hidden]").val(img_src);
            $(this).css("background-image",'url("'+img_src+'")');
        }
    });
};
function guajiang(){
    var arr =$('.loadIframe').find(".curr input");
    for(var i=0;i<arr.length;i++){
        if(arr[i].checked){
            $(".iphoneVirtual").find(".award_id").val($(arr[i]).val());
        }
    }
    cancle_award();
}
function submit_award(){
    var name =$.trim($(".tit").children(".name").val());
    if(name==""){
        tishi_alert("请输入标题");
        return false;
    }
    var title =$.trim($(".tit").children(".title").val());
    if(title==""){
        tishi_alert("请输入文件名");
        return false;
    }
    var top=$(".iphoneVirtual").find(".gglTop").children("input").val();
    if(top==""){
        tishi_alert("顶部未填充");
        return false;
    }
    var bot=$(".iphoneVirtual").find(".gglInfo").children("input");
    for(var i=0;i<bot.length;i++){
        if($(bot[i]).val()==""){
            tishi_alert("低部存在未填充区域");
            return false;
        }
    }
    var vcitem = $(".vstContr").find("input[type=radio]");
    for(var i=0;i<vcitem.length;i++){
        if(vcitem[i].checked){
            $(".iphoneVirtual").find(".vcItem").val($(vcitem[i]).val());
        }
    }
    var form = $(".iphoneVirtual").parent();
    var html = $(".iphoneVirtual").html();
    var name =$(".iphoneVirtual").children(".name").val(name);
    var title =$(".iphoneVirtual").children(".title").val(title);
    $(".iphoneVirtual").find(".html_content").val(html);
    form.submit();
    //var str = form.serialize();
}
function cancle_award(){
    $(".second_bg").hide();
    $(".second_box").hide();
}