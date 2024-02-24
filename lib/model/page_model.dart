class PageModel<T>{
  final List<T>? data;
  final int total_page,current_page,total_items;
  final bool lastLoaded;
  PageModel({this.data, this.total_page=0,this.current_page=0,this.lastLoaded=false,
    this.total_items=0,});


  factory PageModel.fromJson(List<T>? data,Map? map){
    return PageModel(data: data, total_page: map?["lastPage"]??0,
        total_items: map?["total"]??0);
  }

}