import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:doctors_app/data/datas.dart';
import 'package:doctors_app/data/doc_cat_model.dart';
import 'package:doctors_app/data/exception.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Auth with ChangeNotifier {
  String? _token;
  String? _userid;
  DateTime?
      _expiry_Date; //these first three variables are responses coming from backend at the time of sign up or sign in.
  Timer? authTime;
  bool alreadySigned = true;
  String? userName;
  String? Email;
  String? Type;
  String? ImageUrl;

  bool isAuth() {
    if (token == null) return false;
    return true;
  }

  String get userId {
    return _userid ?? '';
  }

  String? get token {
    if (_token != null &&
        _expiry_Date!.isAfter(DateTime.now()) &&
        _userid != null) {
      return _token!;
    }
    return null;
  }

  Map<String, String> get UserInfo {
    return {
      'username': userName ?? '',
      'email': Email ?? '',
      'type': Type ?? '',
      'url': ImageUrl!
    };
  }

  void setAlreadySigned(bool already_signed) {
    alreadySigned = already_signed;
  }

  List<doc_cat_model> _cat_items = [];
  var extractedMapDataForEmail;
  bool doctorStatus = false;
  get_data() async {
    _cat_items = [];
    final url = Uri.parse(
        "https://doctor-92dee-default-rtdb.firebaseio.com/category.json");
    try {
      final response = await http.get(url);
      extractedMapDataForEmail =
          json.decode(response.body) as Map<String, dynamic>;

      extractedMapDataForEmail.forEach((cat_key, cat_data) {
        _cat_items.add(doc_cat_model(
            cat_id: cat_key,
            cat: cat_data['category_name'],
            des: cat_data['category_des'],
            cat_image: cat_data['ImageUrl']));
      });
    } catch (error) {
      print('getting cat error $error');
    }
  }

  bool isDoctorAdded(String email) {
    extractedMapDataForEmail.forEach((cat_key, cat_data) {
      if (cat_data['data'] != null) {
        cat_data['data'].forEach((doc_key, doc_data) {
          if (doc_data['email'] == email) {
            doctorStatus = true;
          }
        });
      }
    });
    return doctorStatus;
  }

  bool result = false;
  Future<void> signUp(
      {String? username,
      String? type,
      String? email,
      String? password,
      File? image}) async {
    if (type == "Doctor") {
      await get_data();

      result = isDoctorAdded(email!);
      if (result == false) {
        throw HttpException("DOCTOR");
      }
    }

    final String Url =
        'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyApwkYs9K2lYrfov7qjF_y3FCdGOmCQLio';
    final response = await http.post(Uri.parse(Url),
        body: json.encode(
            {'email': email, 'password': password, 'returnSecureToken': true}));

    final extractedData = json.decode(response.body);
    if (extractedData['error'] != null) {
      throw HttpException(extractedData['error']['message']);
    }
    _token = extractedData['idToken'];
    _userid = extractedData['localId'];
    _expiry_Date = DateTime.now()
        .add(Duration(seconds: int.parse(extractedData['expiresIn'])));
    autoLogout();

    final ref = FirebaseStorage.instance
        .ref()
        .child('User_Image')
        .child(_userid! + ".jpg");
    await ref.putFile(image!).whenComplete(() => null);
    final image_url = await ref.getDownloadURL();
    final url2 = Uri.parse(
        'https://doctor-92dee-default-rtdb.firebaseio.com/users/$_userid.json?auth=$_token');
    final response2 = await http.post(url2,
        body: json.encode({
          'username': username,
          'email': email,
          'type': type,
          'url': image_url
        }));
    userName = username;
    Email = email;
    Type = type;
    ImageUrl = image_url;
    notifyListeners();

    final pref = await SharedPreferences.getInstance();
    final userinfo = json.encode(
        {'username': username, 'email': email, 'type': type, 'url': ImageUrl});
    await pref.setString('userInfo', userinfo);
    final userdata = json.encode({
      'token': _token,
      'userId': _userid,
      'expiryDate': _expiry_Date!.toIso8601String()
    });
    await pref.setString('userData', userdata);
  }

  Future<void> signIn({String? email, String? password}) async {
    var username;
    var type;
    var imageUrl;
    final String Url =
        'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyApwkYs9K2lYrfov7qjF_y3FCdGOmCQLio';
    final response = await http.post(Uri.parse(Url),
        body: json.encode(
            {'email': email, 'password': password, 'returnSecureToken': true}));

    final extractedData = json.decode(response.body);
    print(extractedData['error']);
    if (extractedData['error'] != null) {
      throw HttpException(extractedData['error']['message']);
    }
    _token = extractedData['idToken'];
    _userid = extractedData['localId'];
    _expiry_Date = DateTime.now()
        .add(Duration(seconds: int.parse(extractedData['expiresIn'])));
    autoLogout();
    final url = Uri.parse(
        'https://doctor-92dee-default-rtdb.firebaseio.com/users/$_userid.json?auth=$_token');
    final userInfoResponse = await http.get(url);
    final extractedMapData =
        json.decode(userInfoResponse.body) as Map<String, dynamic>;
    extractedMapData.forEach((key, data) {
      username = data['username'];
      type = data['type'];
      imageUrl = data['url'];
    });
    userName = username;
    Email = email;
    Type = type;
    ImageUrl = imageUrl;
    // print("printing type at the time of sign in  : $type");
    notifyListeners();
    final pref = await SharedPreferences.getInstance();

    final userinfo = json.encode(
        {'username': username, 'email': email, 'type': type, 'url': ImageUrl});

    await pref.setString('userInfo', userinfo);
    final userdata = json.encode({
      'token': _token,
      'userId': _userid,
      'expiryDate': _expiry_Date!.toIso8601String()
    });
    await pref.setString('userData', userdata);
  }

  void logout() async {
    _token = null;
    _expiry_Date = null;
    _userid = null;
    authTime = null;

    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  Future<bool> autoLogIn() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('userData')) {
      final extractedMap =
          json.decode(prefs.getString('userData')!) as Map<String, dynamic>;
      if (DateTime.parse(extractedMap['expiryDate']).isBefore(DateTime.now()))
        return false;
      _token = extractedMap['token'];
      _userid = extractedMap['userId'];
      _expiry_Date = DateTime.parse(extractedMap['expiryDate']);

      final extractedMapData =
          json.decode(prefs.getString('userInfo')!) as Map<String, dynamic>;
      userName = extractedMapData['username'];
      Email = extractedMapData['email'];
      Type = extractedMapData['type'];
      ImageUrl = extractedMapData['url'];
      print('printing image url $ImageUrl');
      notifyListeners();
      return true;
    } else {
      return false;
    }
  }

  void autoLogout() {
    final expiryTime = _expiry_Date!.difference(DateTime.now()).inSeconds;
    authTime = Timer(Duration(seconds: expiryTime), logout);
  }
}
