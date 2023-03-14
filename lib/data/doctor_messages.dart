import 'dart:convert';
import 'package:doctors_app/data/messages.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class doc_messages with ChangeNotifier {
  String? _token;
  String? _userId;
  void update(String token, String userId) {
    _token = token;
    _userId = userId;
  }

  List<message_model> _doc_message_items = [];
  List<message_model> get doc_message_items {
    return [..._doc_message_items];
  }

  Future get_data(String other_id) async {
    _doc_message_items = [];
    final url = Uri.parse(
        'https://doctor-92dee-default-rtdb.firebaseio.com/Messages/.json?auth=$_token');
    try {
      final response = await http.get(url);
      final extractedMapData =
          json.decode(response.body) as Map<String, dynamic>;
      extractedMapData.forEach((key, data) {
        _doc_message_items.add(message_model(
            id: key,
            text: data['text'],
            createdAt: DateTime.parse(data['createdAt']),
            userId: data['userId']));
      });

      notifyListeners();
    } catch (error) {
      print('getting  error at the time of fetching $error');
    }
  }
}
