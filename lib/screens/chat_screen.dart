import 'package:cached_network_image/cached_network_image.dart';
import 'package:doctors_app/data/datas.dart';
import 'package:doctors_app/data/messages.dart';
import 'package:doctors_app/presentation/color_manager.dart';
import 'package:doctors_app/presentation/presentations.dart';
import 'package:doctors_app/widgets/chats/messages.dart';
import 'package:doctors_app/widgets/chats/new_message.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class chat_screen extends StatefulWidget {
  static const id = "./chat_screen";

  doctor_model doctor;
  doc_extra_details extra_data;
  chat_screen({required this.doctor, required this.extra_data});
  @override
  State<chat_screen> createState() => _chat_screenState();
}

class _chat_screenState extends State<chat_screen> {
  String? user_type;
  bool isLoading = false;
  Future? hasData;
  bool isDataLoading = false;
  @override
  void initState() {
    Map<String, String> userInfo =
        Provider.of<Auth>(context, listen: false).UserInfo;
    user_type = userInfo['type'];
    hasData = Provider.of<MessageData>(context, listen: false)
        .get_data(widget.extra_data.real_id, user_type!);
    super.initState();
  }

  String? otherId;
  Future<void> refeshProductData() async {
    setState(() {
      isLoading = true;
    });
    await Provider.of<MessageData>(context, listen: false)
        .get_data(widget.extra_data.real_id, user_type!);

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
                        imageUrl: widget.extra_data.image,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.02,
                ),
                Text(
                  '${widget.doctor.name}',
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
                          other_user_name: widget.doctor.name,
                          other_user_id: widget.extra_data.real_id);
                    })),
            NewMessage(other_user_id: widget.extra_data.real_id)
          ],
        ),
      ),
    );
  }
}
