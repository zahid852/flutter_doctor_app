import 'dart:convert';

import 'package:doctors_app/data/datas.dart';
import 'package:doctors_app/screens/doc_category.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class doc_extra_details {
  final String real_id;
  final String email;
  final String image;
  doc_extra_details(
      {required this.real_id, required this.email, required this.image});
}

class doc_cat_model {
  final String cat_id;
  final String cat;
  final String des;
  final String cat_image;
  doc_cat_model(
      {this.cat_id = '',
      required this.cat,
      required this.des,
      this.cat_image = ''});
}

class doc_cat_data with ChangeNotifier {
  String? token;
  void update(Auth auth) {
    if (auth.token != null) {
      token = auth.token;
      print("printing not null token : $token");
    } else {
      token = null;
      print("printing null token : $token");
    }
  }

  var extractedMapData;

  List<doc_cat_model> _cat_items = [];

  List<doc_cat_model> get cat_items {
    return [..._cat_items];
  }

  List<doc_extra_details> _user_items = [];

  List<doc_extra_details> get user_items {
    return [..._user_items];
  }

  List<doctor_model> doc_items = [];
  Future<void> add_cat(doc_cat_model dcm) async {
    // final url = Uri.parse(
    //     'https://doctor-92dee-default-rtdb.firebaseio.com/category.json?auth=$token');
    final url = Uri.parse(
        'https://doctor-92dee-default-rtdb.firebaseio.com/category.json');
    try {
      final response = await http.post(url,
          body: json.encode({
            'category_name': dcm.cat,
            'category_des': dcm.des,
            'ImageUrl': dcm.cat_image
          }));

      final cat_item = doc_cat_model(
          cat_id: json.decode(response.body)['name'],
          cat: dcm.cat,
          des: dcm.des,
          cat_image: dcm.cat_image);

      _cat_items.insert(0, cat_item);
      notifyListeners();
    } catch (error) {
      print('cat data error $error');
    }
  }

  Future get_data(String search) async {
    if (!search.contains('Specialist') && search.isNotEmpty) {
      search = search + " Specialist";
    }
    Map<String, dynamic> test_data = {};
    Map<String, dynamic> val;
    final filterString =
        search != '' ? '&orderBy="category_name"&equalTo="$search"' : '';

    _cat_items = [];
    final url = Uri.parse(
        'https://doctor-92dee-default-rtdb.firebaseio.com/category.json');
    // final url = Uri.parse(
    //     'https://doctor-92dee-default-rtdb.firebaseio.com/category.json?auth=$token$filterString');
    final url2 = Uri.parse(
        'https://doctor-92dee-default-rtdb.firebaseio.com/users.json?auth=$token');
    try {
      final response = await http.get(url);
      final user_response = await http.get(url2);
      extractedMapData = json.decode(response.body) as Map<String, dynamic>;
      final userData = json.decode(user_response.body) as Map<String, dynamic>;

      extractedMapData.forEach((cat_key, cat_data) {
        _cat_items.add(doc_cat_model(
            cat_id: cat_key,
            cat: cat_data['category_name'],
            des: cat_data['category_des'],
            cat_image: cat_data['ImageUrl']));
      });

      userData.forEach((user_key, user_data) {
        test_data = user_data;
        test_data.forEach((user_inner_key, user_inner_data) {
          _user_items.add(doc_extra_details(
              real_id: user_key,
              email: user_inner_data['email'],
              image: user_inner_data['url']));
        });
      });

      notifyListeners();
    } catch (error) {
      print('fetching data error $error');
    }
  }

  var da;
  var count = 0;
  List<doctor_model> specific_cat_data(String cat) {
    doc_items = [];
    extractedMapData.forEach((cat_key, cat_data) {
      if (cat == cat_data['category_name']) {
        cat_data['data'] == null
            ? doc_items = []
            : cat_data['data'].forEach((doc_key, doc_data) {
                doc_items.add(doctor_model(
                    id: doc_key,
                    name: doc_data['doc_name'],
                    email: doc_data['email'],
                    experience: doc_data['experience'],
                    practice_location: doc_data['practice_location'],
                    fees: doc_data['fees'],
                    about: doc_data['about'],
                    dis_cat: doc_data['category'],
                    phone: doc_data['phone'],
                    working_days: doc_data['working_days']));
              });
        return;
      }
    });

    print(doc_items);
    return doc_items;
  }
}
