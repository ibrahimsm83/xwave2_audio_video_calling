import 'package:shared_preferences/shared_preferences.dart';

final String key_id='id',key_token='token',key_login='login';

saveDataToPraf(String id,String token)async{

  SharedPreferences sharedPreferences=await SharedPreferences.getInstance();
  await sharedPreferences.reload();
  await sharedPreferences.setString(key_id, id);

  await sharedPreferences.setString(key_token, token);
  await sharedPreferences.setBool(key_login, true);
}

getID_praf()async{
  SharedPreferences sharedPreferences=await SharedPreferences.getInstance();
  await sharedPreferences.reload();

  return sharedPreferences.getString(key_id);
}
getToken_praf()async{
  SharedPreferences sharedPreferences=await SharedPreferences.getInstance();
  await sharedPreferences.reload();

  return sharedPreferences.getString(key_token);
}
getLogin_praf()async{
  SharedPreferences sharedPreferences=await SharedPreferences.getInstance();
  await sharedPreferences.reload();

  return sharedPreferences.getBool(key_login);
}

void clearPreferences() async{
  SharedPreferences sharedPreferences=await SharedPreferences.getInstance();
  sharedPreferences.remove(key_login);
}


