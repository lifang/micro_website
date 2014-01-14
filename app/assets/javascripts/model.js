function submit_model_page(){
   
    var models=$(".main_cont").find(".main_tab");
    alert(models.length);
    for(var i=0;i<models.length;i++){
        if($(models[i]).css("display")!="none"){
            if(i==0){
                alert($(models[i]).html());
            }else if(i==1){

            }else if(i==2){

            }else if(i==3){
                
            }
            
            
            
        }
    }
}