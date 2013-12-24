function add_award_item(){
	var award=$(".award_item");
	var li =$("<li></li>");
	li.html("奖项名：<input type='text' name='name[]'> 奖项内容：  <input type='text' name='content[]'>奖项数：<input type='text' name='number[]'><br> ");
	award.append(li);
}
function remove_award_item(){
	var li=$(".award_item >li");
	$(li[li.length-1]).remove();
}
