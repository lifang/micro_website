function add_award_item(){
	var award=$(".award_item");
	var li =$("<li></li>");
	li.html("奖项名：<input type='text' name='name[]'> 奖项内容：  <input type='text' name='content[]'>奖项数：<input type='text' name='number[]'><span class='close' title='删除该奖项' onclick='remove_award_item(this)'></span> ");
	award.append(li);
}
function remove_award_item(lii){
//	var ul=$(".award_item");
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
