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