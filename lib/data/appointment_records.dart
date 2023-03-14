import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/date_time_patterns.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class appointment_model {
  String? id;
  String doc_name;
  String cat;
  DateTime time;
  String? doc_id;
  appointment_model(
      {this.id,
      required this.doc_name,
      required this.cat,
      required this.time,
      this.doc_id});
}

class doc_appointment_model {
  String patient_name;
  String cat;
  DateTime time;
  doc_appointment_model({
    required this.patient_name,
    required this.cat,
    required this.time,
  });
}

class doc_appointment {
  String? user_id;
  String? username;
  String? userImage;
  doc_appointment(
      {required this.user_id, required this.username, required this.userImage});
}

class appointment with ChangeNotifier {
  String? _token;
  String? _userId;

  void update(String token, String userId) {
    _token = token;
    _userId = userId;
  }

  bool isAppointmentValid = true;
  List<appointment_model> _app_items = [];
  List<appointment_model> get app_items {
    return [..._app_items];
  }

  List<doc_appointment> _doc_apps = [];
  List<doc_appointment> get doc_apps {
    return [..._doc_apps];
  }

  List<doc_appointment_model> _doctor_apps = [];
  List<doc_appointment_model> get doctor_apps {
    return [..._doctor_apps];
  }

  List<doc_appointment> all_user_data = [];
  int count = 0;
  var extractedMapDataForEmail;
  var doctor_id;
  get_user_data(String email) async {
    final url = Uri.parse(
        "https://doctor-92dee-default-rtdb.firebaseio.com/users.json");
    try {
      final response = await http.get(url);
      extractedMapDataForEmail =
          json.decode(response.body) as Map<String, dynamic>;

      extractedMapDataForEmail.forEach((user_real_key, user_dummy_data) {
        user_dummy_data.forEach((user_key, user_real_data) {
          if (email == user_real_data['email']) {
            doctor_id = user_real_key;
          }
        });
      });
      print('user real key ${doctor_id}');
    } catch (error) {
      print('getting user error $error');
    }
  }

  Future<bool> add_app(appointment_model appointment, String email) async {
    await get_data();
    isAppointmentValid = true;
    for (var appointment_model in _app_items) {
      if (24 > DateTime.now().difference(appointment_model.time).inHours) {
        if (appointment_model.cat == appointment.cat) {
          isAppointmentValid = false;
        }
      }
    }
    if (isAppointmentValid == false) {
      return isAppointmentValid;
    }
    await get_user_data(email);
    final url = Uri.parse(
        'https://doctor-92dee-default-rtdb.firebaseio.com/usersAppointments/$_userId.json?auth=$_token');
    try {
      final response = await http.post(url,
          body: json.encode({
            'doc_name': appointment.doc_name,
            'cat': appointment.cat,
            'time': appointment.time.toIso8601String(),
            'doc_id': doctor_id
          }));
      final app_item = appointment_model(
          id: json.decode(response.body)['name'],
          doc_name: appointment.doc_name,
          cat: appointment.cat,
          time: appointment.time,
          doc_id: doctor_id);

      _app_items.insert(0, app_item);
      notifyListeners();

      return isAppointmentValid;
    } catch (error) {
      return false;
    }
  }

  Future get_data() async {
    _app_items = [];
    final url = Uri.parse(
        'https://doctor-92dee-default-rtdb.firebaseio.com/usersAppointments/$_userId.json?auth=$_token');
    try {
      final response = await http.get(url);
      final extractedMapData =
          json.decode(response.body) as Map<String, dynamic>?;
      print(extractedMapData);
      if (extractedMapData != null) {
        extractedMapData.forEach((user_key, user_data) {
          _app_items.add(appointment_model(
              id: user_key,
              doc_name: user_data['doc_name'],
              cat: user_data['cat'],
              time: DateTime.parse(user_data['time']),
              doc_id: user_data['doc_id']));
        });
        _app_items = _app_items.reversed.toList();
      }

      notifyListeners();
    } catch (error) {
      print(" get data error $error");
    }
  }

  Future get_doc_appointments(String doc_id) async {
    _doc_apps = [];
    final url = Uri.parse(
        'https://doctor-92dee-default-rtdb.firebaseio.com/usersAppointments.json?auth=$_token');
    try {
      final response = await http.get(url);
      final extractedMapData =
          json.decode(response.body) as Map<String, dynamic>?;

      if (extractedMapData != null) {
        await get_all_user_data();
        extractedMapData.forEach((user_key, user_data) {
          user_data.forEach((user_inner_key, user_inner_data) {
            if (doc_id == user_inner_data['doc_id']) {
              all_user_data.forEach((ele) {
                if (ele.user_id == user_key) {
                  _doc_apps.add(ele);
                }
              });
            }
          });
        });
        _doc_apps.forEach((element) {
          print('name is ${element.username}');
        });
        _doc_apps = _doc_apps.reversed.toList();
      }
      notifyListeners();
    } catch (error) {
      print(" get data error $error");
    }
  }

  get_all_user_data() async {
    all_user_data = [];
    final url = Uri.parse(
        "https://doctor-92dee-default-rtdb.firebaseio.com/users.json");
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;

      extractedData.forEach((user_key, user_data) {
        user_data.forEach((user_inner_key, user_inner_data) {
          all_user_data.add(doc_appointment(
              user_id: user_key,
              username: user_inner_data['username'],
              userImage: user_inner_data['url']));
        });
      });
      // all_user_data.forEach((element) {
      //   print('all data ${element.username}');
      // });
    } catch (error) {
      print('getting user error $error');
    }
  }

  Future get_doctor_appointments(String doc_id) async {
    _doctor_apps = [];
    final url = Uri.parse(
        'https://doctor-92dee-default-rtdb.firebaseio.com/usersAppointments.json?auth=$_token');
    try {
      final response = await http.get(url);
      final extractedMapData =
          json.decode(response.body) as Map<String, dynamic>?;

      if (extractedMapData != null) {
        await get_all_user_data();
        extractedMapData.forEach((user_key, user_data) {
          user_data.forEach((user_inner_key, user_inner_data) {
            if (doc_id == user_inner_data['doc_id']) {
              all_user_data.forEach((ele) {
                if (ele.user_id == user_key) {
                  _doctor_apps.add(doc_appointment_model(
                      patient_name: ele.username!,
                      cat: user_inner_data['cat'],
                      time: DateTime.parse(user_inner_data['time'])));
                }
              });
            }
          });
        });

        _doctor_apps = _doctor_apps.reversed.toList();
      }
      _doctor_apps.forEach((element) {
        print('name is ${element.patient_name}');
        print('name is ${element.cat}');
        print('name is ${element.time}');
      });
      notifyListeners();
    } catch (error) {
      print(" get data error $error");
    }
  }
}
