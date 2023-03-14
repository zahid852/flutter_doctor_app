import 'dart:convert';
import 'package:doctors_app/data/auth_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class message_model {
  String? id;
  final String text;
  final DateTime createdAt;
  final String userId;
  message_model(
      {this.id,
      required this.text,
      required this.createdAt,
      required this.userId});
}

class MessageData with ChangeNotifier {
  String? _token;
  String? _userId;
  void update(String token, String userId) {
    _token = token;
    _userId = userId;
  }

  List<message_model> _message_items = [];

  List<message_model> get message_items {
    return [..._message_items];
  }

  Future<void> add_message(
      String message, DateTime date, String other_user_id, String type) async {
    String chatId;
    if (type == 'Doctor') {
      chatId = '${other_user_id}-${_userId}';
    } else {
      chatId = '${_userId}-${other_user_id}';
    }
    final url = Uri.parse(
        'https://doctor-92dee-default-rtdb.firebaseio.com/Messages/$chatId.json?auth=$_token');
    try {
      final response = await http.post(url,
          body: json.encode({
            'text': message,
            'createdAt': date.toIso8601String(),
            'userId': _userId
          }));

      final message_item = message_model(
          id: json.decode(response.body)['name'],
          text: message,
          createdAt: date,
          userId: _userId!);

      _message_items.add(message_item);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future get_data(String other_user_id, String type) async {
    String chatId;
    if (type == 'Doctor') {
      chatId = '${other_user_id}-${_userId}';
    } else {
      chatId = '${_userId}-${other_user_id}';
    }

    _message_items = [];
    final url = Uri.parse(
        'https://doctor-92dee-default-rtdb.firebaseio.com/Messages/$chatId.json?auth=$_token');
    try {
      final response = await http.get(url);

      if (json.decode(response.body) == null) {
        return;
      }
      final extractedMapData =
          json.decode(response.body) as Map<String, dynamic>;

      extractedMapData.forEach((key, data) {
        _message_items.add(message_model(
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
