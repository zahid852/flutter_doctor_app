import 'package:cached_network_image/cached_network_image.dart';
import 'package:doctors_app/data/datas.dart';
import 'package:doctors_app/data/messages.dart';
import 'package:doctors_app/presentation/color_manager.dart';
import 'package:doctors_app/presentation/presentations.dart';
import 'package:doctors_app/widgets/chats/messages.dart';
import 'package:doctors_app/widgets/chats/new_message.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class doctor_chat_screen extends StatefulWidget {
  static const id = "./chat_screen";
  final String other_user_name;
  final String other_user_id;
  final String other_user_image;

  doctor_chat_screen(
      {required this.other_user_name,
      required this.other_user_id,
      required this.other_user_image});

  @override
  State<doctor_chat_screen> createState() => _doctor_chat_screenState();
}

class _doctor_chat_screenState extends State<doctor_chat_screen> {
  String? user_type;
  bool isLoading = false;
  Future? hasData;
  @override
  void initState() {
    Map<String, String> userInfo =
        Provider.of<Auth>(context, listen: false).UserInfo;
    user_type = userInfo['type'];
    hasData = Provider.of<MessageData>(context, listen: false)
        .get_data(widget.other_user_id, user_type!);
    super.initState();
  }

  Future<void> refeshProductData() async {
    setState(() {
      isLoading = true;
    });
    await Provider.of<MessageData>(context, listen: false)
        .get_data(widget.other_user_id, user_type!);
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: MediaQuery.of(context).size.height * 0.08,
        backgroundColor: ColorManager.primery,
        titleSpacing: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: CircleAvatar(
                    radius: MediaQuery.of(context).size.height * 0.03,
                    backgroundColor: Colors.white,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(
                          MediaQuery.of(context).size.height * 0.06),
                      child: CachedNetworkImage(
                        height: 49,
                        width: 49,
                        imageUrl: widget.other_user_image,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.02,
                ),
                Text(
                  '${widget.other_user_name}',
                  style: getMediumStyle(color: Colors.white, fontsize: 18),
                ),
              ],
            ),
            isLoading
                ? Container(
                    padding: EdgeInsets.only(right: 15),
                    child: CircleAvatar(
                      backgroundColor: ColorManager.primery,
                      radius: MediaQuery.of(context).size.height * 0.01,
                      child: CircularProgressIndicator(
                        color: Colors.red,
                      ),
                    ),
                  )
                : IconButton(
                    onPressed: () {
                      refeshProductData();
                    },
                    icon: Icon(Icons.refresh))
          ],
        ),
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(
                child: FutureBuilder(
                    future: hasData,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      return Messages(
                          futureMessage: refeshProductData,
                          other_user_name: widget.other_user_name,
                          other_user_id: widget.other_user_id);
                    })),
            NewMessage(other_user_id: widget.other_user_id)
          ],
        ),
      ),
    );
  }
}
