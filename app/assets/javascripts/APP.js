function add_info_box(value){
	var val = $($(value).parents(".second_content")[0]).find(".insetBox").find("input").val();
	if($.trim(val)==""){
		tishi_alert("信息栏不能为空");
		return false;
	}
	var index = $("#info_inedx").val();index++;
	$("#info_inedx").val(index);
	var html = "<div class='itemBox'><span class='close' onclick='cancle_aitem(this)'></span><label>"+val+"<input type='hidden' name='form["+index+"text][name]' value='"+val+"' /></label><input type='text' /></div>" ;
	$(".appInfo").append(html);
	cancle_info_box(value);
}


//增加单选按钮
function add_opt_box(value){
	var divarr = $($(value).parents(".second_content")[0]).find(".insetBox").find("div");
	var radtext = $(divarr[0]).find("input").val();
	var index = $("#info_inedx").val();index++;
	$("#info_inedx").val(index);
	var html= "<div class='itemBox'><span class='close' onclick='cancle_aitem(this)'></span><div><span>"+radtext+"<input type='hidden' name='form["+index+"radio][name]' value='"+radtext+"' /></span></div>";
	for(var i=1;i<divarr.length;i++){
		var val = $(divarr[i]).find("input").val();
		if($.trim(val)!=""){
			
		html += "<div class='opt rad'><input type='radio' /><span>"+val+"<input type='hidden' name='form["+index+"radio][value][]' value='"+val+"' /></span></div>";
		}
	}
	html+="</div>";
	$(".appInfo").append(html);
	cancle_info_box(value);
}
//增加复选框
function add_Chek_box(value){
	var divarr = $($(value).parents(".second_content")[0]).find(".insetBox").find("div");
	var radtext = $(divarr[0]).find("input").val();
	var index = $("#info_inedx").val();index++;
	$("#info_inedx").val(index);
	var html= "<div class='itemBox'><span class='close' onclick='cancle_aitem(this)'></span><div><span>"+radtext+"<input type='hidden' name='form["+index+"checkbox][name]' value='"+radtext+"' /></span></div>";
	for(var i=1;i<divarr.length;i++){
		var val = $(divarr[i]).find("input").val();
		if($.trim(val)!=""){
			
		html += "<div class='opt chk'><input type='checkbox' /><span>"+val+"<input type='hidden' name='form["+index+"checkbox][value][]' value='"+val+"' /></span></div>";
		}
	}
	html+="</div>";
	$(".appInfo").append(html);
	cancle_info_box(value);
}
//增加下拉框
function add_text_box(value){
	var divarr = $($(value).parents(".second_content")[0]).find(".insetBox").find("div");
	var radtext = $(divarr[0]).find("input").val();
	var index = $("#info_inedx").val();index++;
	$("#info_inedx").val(index);
	
	var html= "<div class='itemBox'><span class='close' onclick='cancle_aitem(this)'></span><label>"+radtext+"<input type='hidden' name='form["+index+"select][name]' value='"+radtext+"' /></label><select>";
	var hidden = "";
	for(var i=1;i<divarr.length;i++){
		var val = $(divarr[i]).find("input").val();
		if($.trim(val)!=""){
			
		html += "<option value='"+i+"'>"+val+" </option>";
		hidden += "<input type='hidden' name='form["+index+"select][value][]' value='"+val+"' />";
		}
	}
	html+="</select>"+hidden+"</div>";
	$(".appInfo").append(html);
	cancle_info_box(value);
}


function cancle_info_box(value){
	$(".second_bg").hide();
	$($(value).parents(".addItem")[0]).hide();
	
	
}
function cancle_aitem(value){
	$(value).parent().remove();
}
function create_client_info_model(){
	$("#html_content").val($(".appInfo").html());
	$(".appInfo").parent().submit();
}


