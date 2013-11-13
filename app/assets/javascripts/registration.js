

function check(){
	
	
	//checkName();
	//checkPassword();
	//checkEmail();
	//checkPhone();
	
	flg=(checkName()&&checkPassword()&&checkEmail()&&checkPhone());
	
	return flg;
}
function checkName(){
	
	flg=true;
	var name = document.getElementById('user_name');
	
	if((name.value.trim().length)==0){
		alert('提示:\n\n用户名不能为空');		
		flg=false;
	}
	
	return flg;
}
function checkPassword(){
	
	var flg=false;
	var password = document.getElementById('user_password').value;	
	var repassword = document.getElementById('user_password_confirmation').value;
	

	if(password.length>=6){
		if(password==repassword){
			flg=true;
			}else{
		alert("提示:\n\n两次密码输入不一致");
		}		
	}else{
		alert("提示:\n\n请输入长度大于6的密码");
		}	
	return flg;
}


function checkEmail(){
	
	flg=true;
	var email = document.getElementById('user_email').value;
	var emailReg = /^([a-zA-Z0-9]+[_|\_|\.]?)*[a-zA-Z0-9]+@([a-zA-Z0-9]+[_|\_|\.]?)*[a-zA-Z0-9]+\.[a-zA-Z]{2,3}$/;
	
	 if(!emailReg.test(email))
            {
                alert('提示:\n\n请输入有效的E_mail');                 
                flg=false;
           }
		
	return flg;
	
}



function checkPhone(){
	flg=true;
	var phone = document.getElementById('user_phone').value;
	var phoneReg =/^1[3458]\d{9}$/;
	if(!phoneReg.test(phone)){
		alert('提示:\n\n请输入有效的联系电话。');                 
		flg=false;
	}
	
	return flg;
}

