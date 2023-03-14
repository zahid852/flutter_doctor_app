import 'package:doctors_app/data/auth_data.dart';
import 'package:doctors_app/data/datas.dart';
import 'package:doctors_app/data/messages.dart';
import 'package:doctors_app/presentation/presentations.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class Messages extends StatefulWidget {
  final Function futureMessage;
  String other_user_name;
  String other_user_id;
  Messages(
      {required this.futureMessage,
      required this.other_user_name,
      required this.other_user_id});
  @override
  State<Messages> createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  Future? get_message;
  @override
  void initState() {
    get_message = widget.futureMessage();
    // TODO: implement initState
    super.initState();
  }

  bool isMe = false;
  String? date;
  @override
  Widget build(BuildContext context) {
    final login_user_info = Provider.of<Auth>(context, listen: false).UserInfo;
    final String login_userId =
        Provider.of<Auth>(context, listen: false).userId;
    return Container(
        child: FutureBuilder(
            future: get_message,
            builder: (context, snapshot) {
              if (ConnectionState.waiting == snapshot.connectionState) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                return (Consumer<MessageData>(
                  builder: (context, data, _) {
                    if (data.message_items.isEmpty) {
                      return Center(
                        child: Text(
                          '',
                          style: getRegulerStyle(
                              color: ColorManager.primery, fontsize: 18),
                        ),
                      );
                    }
                    return ListView.builder(
                        physics: BouncingScrollPhysics(),
                        itemCount: data.message_items.length,
                        itemBuilder: (context, index) {
                          date = DateFormat('hh:mm a')
                              .format(data.message_items[index].createdAt);
                          if (login_userId ==
                              data.message_items[index].userId) {
                            isMe = true;
                          } else {
                            isMe = false;
                          }
                          return isMe == false
                              ? Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 10),
                                  alignment: Alignment.centerLeft,
                                  margin: EdgeInsets.fromLTRB(5, 2, 0, 2),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          login_userId ==
                                                  data.message_items[index]
                                                      .userId
                                              ? 'You'
                                              : widget.other_user_name,
                                          style: getMediumStyle(
                                              color: Colors.black,
                                              fontsize: 15),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Container(
                                        alignment: Alignment.centerLeft,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.6,
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Container(
                                              child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: Colors.blue[100],
                                            ),
                                            padding: EdgeInsets.fromLTRB(
                                                10, 10, 10, 5),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  '${data.message_items[index].text}',
                                                  style: getRegulerStyle(
                                                      color: Colors.black,
                                                      fontsize: 15),
                                                ),
                                                SizedBox(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.008,
                                                ),
                                                Text(
                                                  date!,
                                                  style: getRegulerStyle(
                                                      color: Colors.black54,
                                                      fontsize: 13),
                                                ),
                                              ],
                                            ),
                                          )),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : Container(
                                  alignment: Alignment.centerRight,
                                  margin: EdgeInsets.fromLTRB(0, 2, 5, 2),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 10),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        alignment: Alignment.centerRight,
                                        child: Text(
                                          login_userId ==
                                                  data.message_items[index]
                                                      .userId
                                              ? 'You'
                                              : widget.other_user_name,
                                          style: getMediumStyle(
                                              color: Colors.black,
                                              fontsize: 15),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.6,
                                        child: Align(
                                          alignment: Alignment.centerRight,
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color: ColorManager
                                                    .primeryOpacity70,
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            padding: EdgeInsets.fromLTRB(
                                                10, 10, 10, 5),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  '${data.message_items[index].text}',
                                                  style: getRegulerStyle(
                                                      color: Colors.white,
                                                      fontsize: 15),
                                                ),
                                                SizedBox(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.008,
                                                ),
                                                Text(
                                                  date!,
                                                  style: getRegulerStyle(
                                                      color: Colors.white70,
                                                      fontsize: 13),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                        });
                  },
                ));
              }
            }));
  }
}
