import 'package:chat_app_with_myysql/helper/MyPraf.dart';
import 'package:get/get.dart';

class ApiService extends GetConnect{

  simpleGetApi(String api)async{
    final response= await get(api);
    if(response.status.hasError){
      return Future.error(response.statusText!);
    }else{
      return response;
    }
  }

  getApiWithBody(String api,Map<String, dynamic> body)async{
    return await get(api,query: body,contentType: 'application/json');
  }
  getApiWithToken(String api)async{
    String header=await getToken_praf();
    return await get(api,headers: {'Authorization': 'Bearer $header'});
  }



  postApiWithBody(String api,Map<String,dynamic> body)async{
    final response= await post(api, body,);
    print("--ApiServices Response----${response}");
    if(response.status.hasError){
      return Future.error(response.statusText!);
    }else{
      return response;
    }
  }
  postApiWithFromData(String api,Map<String,dynamic> body)async{
    return await post(api, FormData(body),);
  }
  postApiWithFromDataAndHeaderAndContantType(String api,Map<String,dynamic> body)async{
    String header=await getToken_praf();
    final response= await post(api, FormData(body), headers: {'Authorization': 'Bearer $header'},contentType: 'multipart/form-data');
   print("--ApiServices Response----${response}");
    if(response.status.hasError){
      return Future.error(response.statusText!);
    }else{
      return response;
    }

  }


  postApiWithHeaderAndBody(String api,Map<String,dynamic> body)async{
    String header=await getToken_praf();
    return await post(api, body,
        headers: {'Authorization': 'Bearer $header'});
  }

}