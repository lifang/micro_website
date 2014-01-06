function edit_micro_imgtext(sid,mmsid,mimgid){

    $.ajax({
        async:true,
        type : 'get',
        url:'/sites/'+sid+'/micro_imgtexts/'+mmsid+'/edit',
        dataType:"script",
        data  :"&site_id=" + sid +"&micro_message_id=" + mmsid +"&micro_imgtext_id=" + mimgid,
        success:function(data){
            
        }
    });
}

function delete_micro_imgtext(sid,mmsid,mimgid){

    $.ajax({
        async:true,
        type : 'delete',
        url:'/sites/'+sid+'/micro_imgtexts/'+mmsid,
        dataType:"text",
        data  :"&site_id=" + sid +"&micro_message_id=" + mmsid +"&micro_imgtext_id=" + mimgid,
        success:function(data){
            if(data==1){
                tishi_alert('删除成功！');
                location.reload();
            }
        }
    });
}

function check_new_micro_imgtexts(value){
   
    var title=$("#micro_imgtexts_title").val();
    
    if( $.trim(title)=="" ){
        alert('标题不能为空！');
        return false;
    }
     var file=$(".fileText_1").val();
  
    if($.trim(file)==""){
        alert('请选择文件！');
        return false;
    }
    var content=$("#micro_imgtexts_img_path").val();

    if($.trim(content)==""){
        alert('内容不能为空！');
        return false;
    }
    var url=$("#micro_imgtexts_url").val();
    if($.trim(url)==""){
        alert('url不能为空！');
        return false;
    }
    $("#uploadmicro").submit();
}