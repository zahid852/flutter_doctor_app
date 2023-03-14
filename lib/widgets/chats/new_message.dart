import 'package:doctors_app/data/auth_data.dart';
import 'package:doctors_app/data/messages.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../presentation/presentations.dart';

class NewMessage extends StatefulWidget {
  final String other_user_id;
  NewMessage({required this.other_user_id});
  @override
  State<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  TextEditingController messageController = TextEditingController();
  String? enteredMessage;
  void _sendMessage(BuildContext context) async {
    Map<String, String> userdata =
        Provider.of<Auth>(context, listen: false).UserInfo;
    await Provider.of<MessageData>(context, listen: false).add_message(
        enteredMessage!,
        DateTime.now(),
        widget.other_user_id,
        userdata['type']!);
    messageController.clear();
    enteredMessage = '';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(15, 10, 10, 10),
      child: Row(children: [
        Expanded(
          child: TextField(
            controller: messageController,
            style: getRegulerStyle(color: Colors.black, fontsize: 16),
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 2),
              hintText: "Type message here ",
              hintStyle: getRegulerStyle(color: Colors.grey, fontsize: 14),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                  borderRadius: BorderRadius.circular(30)),
              border: OutlineInputBorder(
                  borderSide: BorderSide(color: ColorManager.primery),
                  borderRadius: BorderRadius.circular(30)),
            ),
            onChanged: (value) {
              setState(() {
                enteredMessage = value;
              });
            },
          ),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.03,
        ),
        IconButton(
          onPressed:
              enteredMessage == null ? null : () => _sendMessage(context),
          icon: Icon(
            Icons.send,
            color: ColorManager.primery,
          ),
        ),
      ]),
    );
  }
}
