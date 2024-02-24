import 'package:chat_app_with_myysql/util/MyPraf.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class ApiService{

  Future<http.Response> simpleGetApi(String api)async{
    final response= await http.get(Uri.parse(api));
    return response;
/*    if(response.status.hasError){
      return Future.error(response.statusText!);
    }else{
      return response;
    }*/
  }

 /* Future<http.Response> getApiWithBody(String api,Map<String, dynamic> body)async{
    return await http.get(Uri.parse(api),);
  }*/
  Future<http.Response> getApiWithToken(String api)async{
    String header=await getToken_praf();
    return await http.get(Uri.parse(api),headers: {'Authorization': 'Bearer $header'});
  }



  Future<http.Response> postApiWithBody(String api,dynamic body)async{
    final response= await http.post(Uri.parse(api), body:body,
        headers: {'Content-type': (body is String)?'application/json':
        "application/x-www-form-urlencoded"});
    print("--ApiServices Response-postApiWithBody---${response}");
    return response;
/*    if(response.status.hasError){
      return Future.error(response.statusText!);
    }else{
      return response;
    }*/
  }
  Future<http.StreamedResponse> postApiWithFromData(String api,
      Map<String,String> body,{List<http.MultipartFile> files=const [],})async{
    var postUri = Uri.parse(api);
    var request = http.MultipartRequest("POST", postUri);
    request.fields.addAll(body);
    request.files.addAll(files);
    return await request.send();

   // return await post(api, FormData(body),);
  }
  Future<http.StreamedResponse> postApiWithFromDataAndHeaderAndContantType(String api,Map<String,String> body,
      {List<http.MultipartFile> files=const [],})async{
    String header=await getToken_praf();
    var postUri = Uri.parse(api);
    var request = http.MultipartRequest("POST", postUri);
    request.headers.addAll({'Authorization': 'Bearer $header'});
    request.fields.addAll(body);
    request.files.addAll(files);
    return await request.send();
   // print(body['media']);
/*    final response= await post(api, FormData(body), headers: {'Authorization': 'Bearer $header'},contentType: 'multipart/form-data');
   //print("--ApiServices Response-headers-postApiWithFromDataAndHeaderAndContantType --${response.statusText}");
   print("--ApiServices Response body- --${response.body}");
    if(response.status.hasError){
      return Future.error(response.statusText!);
    }else{
      return response;
    }*/
  }

  Future<http.Response> postApiWithHeaderAndBody(String api,dynamic body)async{
    String header=await getToken_praf();
    print("api header: $header");
    print("api body: $body");
    return await http.post(Uri.parse(api), body: body,
        headers: {'Authorization': 'Bearer $header',
          'Content-type': (body is String)?'application/json':
          "application/x-www-form-urlencoded"});
  }

}
