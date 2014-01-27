function delete_site(id){
    if(confirm('确定删除？'))
    window.location.href="/destroy_site?id="+id;

}