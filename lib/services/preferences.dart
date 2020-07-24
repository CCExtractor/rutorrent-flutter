import 'dart:convert';
import 'package:rutorrentflutter/api/api_conf.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Preferences {

  static clearLogin() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('data');
  }

  static saveLogin(List<Api> apis) async{
    final String data = Preferences.encodeApis(apis);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('data', data);
  }

  static Future<List<Api>> fetchSavedLogin() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(prefs.containsKey('data'))
      return decodeApis(prefs.getString('data'));
    else
      return [];
  }

  static Api fromJson(Map<String, dynamic> jsonData) {
    Api api = Api();
    api.setUrl(jsonData['url']);
    api.setUsername(jsonData['username']);
    api.setPassword(jsonData['password']);
    return api;
  }

  static Map<String, dynamic> toMap(Api api) =>{
    'url': api.url,
    'username': api.username,
    'password': api.password,
  };

  static String encodeApis(List<Api> apis)=> json.encode(
    apis.
      map<Map<String, dynamic>>((api) => Preferences.toMap(api))
        .toList(),
  );

  static List<Api> decodeApis(String data) =>
      (json.decode(data) as List<dynamic>)
          .map<Api>((item) => Preferences.fromJson(item))
          .toList();
}