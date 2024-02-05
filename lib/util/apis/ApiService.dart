import 'package:chat_app_with_myysql/util/MyPraf.dart';
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
    print("--ApiServices Response-postApiWithBody---${response}");
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
    print("--body- --${body}");
   // print(body['media']);
    final response= await post(api, FormData(body), headers: {'Authorization': 'Bearer $header'},contentType: 'multipart/form-data');
   //print("--ApiServices Response-headers-postApiWithFromDataAndHeaderAndContantType --${response.statusText}");
   print("--ApiServices Response body- --${response.body}");
    if(response.status.hasError){
      return Future.error(response.statusText!);
    }else{
      return response;
    }
  }

  postApiWithHeaderAndBody(String api,Map<String,dynamic> body)async{
    String header=await getToken_praf();
    print("api header: $header");
    print("api body: $body");
    return await post(api, body,
        headers: {'Authorization': 'Bearer $header'});
  }

}