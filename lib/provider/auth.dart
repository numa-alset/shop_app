// import 'dart:html';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/http_exception.dart';
import 'package:shared_preferences/shared_preferences.dart';
class Auth with ChangeNotifier{
  String? _token;
  DateTime? _expiryDate;
  String? _userId;
  Timer? _authTimer;

  bool get isAuth{
    print('im is auth');
    if(token==null){print('im is auth false nulll');return false;}
     else if(token!.isEmpty){print('im is auth false');return false;}
    else{
      print('im is auth true');return true;
    }

    // return token!=null||token!.isNotEmpty;
  }

  String? get token{
    print('im is atoken');
    print(_token);

    if(_token==null){print('im is atoken1'); return '';}
    if(_expiryDate==DateTime(0)){print('im is atoken 2');return'';}
    if(_expiryDate==null && _expiryDate!.isBefore(DateTime.now()) && _token!.isEmpty){print('im is atoken3');return '';}
    // if (_expiryDate!=null && _expiryDate!.isAfter(DateTime.now()) && (_token!=null||_token!.isNotEmpty)){
    else{print('im is atoken 4'); return _token;}

    // }
    // return '';
  }

  Future<void> signup(String email,String password)async{
   final url=Uri.parse('https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyDszFnoudbTo8zX6JJLhLXR3yHQjiPta9w');
   try {
     final response = await http.post(url, body: json.encode(
         {'email': email, 'password': password, 'returnSecureToken': true}));
     final responseData=json.decode(response.body);
     if(responseData['error']!=null){
       throw HttpException(responseData['error']['message']);
     }
     _token=responseData['idToken'];
     _userId=responseData['localId'];
     _expiryDate=DateTime.now().add(Duration(seconds:int.parse( responseData['expiresIn'])),);
     _autoLogout();
     notifyListeners();
     final prefs = await SharedPreferences.getInstance();
     final userData=json.encode({
       'token':_token,
       'userId':_userId,
       'expiryDate':_expiryDate?.toIso8601String()
     });
     prefs.setString('userData', userData);
   }catch(error){
     throw error;
   }
  }
  String? get userId{
    if(_userId==null){return '';}
    else
    return _userId;
  }
  Future<void> login(String email,String password)async{
   final url=Uri.parse('https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyDszFnoudbTo8zX6JJLhLXR3yHQjiPta9w');
    try {
      final response = await http.post(url, body: json.encode(
          {'email': email, 'password': password, 'returnSecureToken': true}));
      final responseData=json.decode(response.body);
      if(responseData['error']!=null){
        throw HttpException(responseData['error']['message']);
      }
      _token=responseData['idToken'];
      _userId=responseData['localId'];
      _expiryDate=DateTime.now().add(Duration(seconds:int.parse( responseData['expiresIn'])),);
      _autoLogout();
      print('i am login 1');
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      print('i am login 2');
      final userData=json.encode({
        'token':_token,
        'userId':_userId,
        'expiryDate':_expiryDate?.toIso8601String()
      });
      prefs.setString('userData', userData);
    }catch(error){
      throw error;
    }
  }
  Future<bool> tryAutoLogin()async{
    print('i am try auto login ');
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    _token=json.decode(prefs.getString('userData')!)["token"];
    _userId=json.decode(prefs.getString('userData')!)["userId"];
    _expiryDate=DateTime.parse(json.decode(prefs.getString('userData')!)["expiryDate"]);
    print("token done");
    notifyListeners();
    _autoLogout();
    return true;
    // print(prefs.getString('userData'));
    // print('done');
    // if(!prefs.containsKey('userData')){
    //   print('shared contain key');
    //   return false;
    // }
    // if(prefs.getString('userData')==null)return false;
    // final extractedUserData=json.decode(prefs.getString('userData')!)as Map<String,Object>;
    // final expiryDate=DateTime.parse(extractedUserData['expiryDate']as String);
    // if(expiryDate.isBefore(DateTime.now())){
    //   print("im in expiry");
    //   return false;
    // }

  }

  Future<void> logout()async {
    _token='';
    _userId='';
    _expiryDate=DateTime(0);
    if(_authTimer!=null){
      _authTimer!.cancel();
      _authTimer=null;
    }
    notifyListeners();
    final prefs=await SharedPreferences.getInstance();
    prefs.clear();
  }
  void _autoLogout(){
    print('i am log out ');
    if(_authTimer!=null){_authTimer!.cancel();}
    final timeToExpiry= _expiryDate?.difference(DateTime.now()).inSeconds;
    _authTimer=Timer(Duration(seconds: timeToExpiry!),() => logout(),);
  }

}