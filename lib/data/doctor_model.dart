import 'dart:convert';
import 'dart:ffi';

import 'package:doctors_app/data/datas.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class doctor_model {
  final String? id;
  final String name;
  final String email;
  final String experience;
  final String practice_location;
  final int fees;
  final Map<String, dynamic> working_days;
  final String dis_cat;
  final String phone;
  final String about;

  doctor_model({
    this.id,
    required this.name,
    required this.email,
    required this.experience,
    required this.practice_location,
    required this.fees,
    this.working_days = const {
      'Monday': null,
      'Tuesday': null,
      'Wednesday': null,
      'Thursday': null,
      'Friday': null,
      'Saturday': null,
      'Sunday': null,
    },
    required this.about,
    required this.dis_cat,
    required this.phone,
  });
}

List<doctor_model> _doc_items = [];
List<doctor_model> get doc_items {
  return [..._doc_items];
}

class doctor with ChangeNotifier {
  String? _token;
  String? _userId;
  void update(String token, String _userId) {
    _token = token;
    _userId = _userId;
  }

  doc_cat_model doc_category = doc_cat_model(cat: '', des: '');

  Future<void> add_doctor(doctor_model dm, List<doc_cat_model> dcm) async {
    dcm.forEach((element) {
      if (element.cat == dm.dis_cat) {
        doc_category = element;
      }
    });

    final url = Uri.parse(
        'https://doctor-92dee-default-rtdb.firebaseio.com/category/${doc_category.cat_id}/data.json?auth=$_token');
    try {
      final response = await http.post(url,
          body: json.encode({
            'doc_name': dm.name,
            'email': dm.email,
            'experience': dm.experience,
            'fees': dm.fees,
            'practice_location': dm.practice_location,
            'working_days': dm.working_days,
            'phone': dm.phone,
            'about': dm.about,
            'category': dm.dis_cat,
          }));
      final doc_item = doctor_model(
          id: json.decode(response.body)['name'],
          name: dm.name,
          email: dm.email,
          experience: dm.experience,
          practice_location: dm.practice_location,
          fees: dm.fees,
          about: dm.about,
          dis_cat: dm.dis_cat,
          working_days: dm.working_days,
          phone: dm.phone);

      _doc_items.insert(0, doc_item);
      notifyListeners();
    } catch (error) {
      print('error $error');
      throw error;
    }
  }
}
