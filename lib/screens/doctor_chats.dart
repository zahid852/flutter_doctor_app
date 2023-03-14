import 'package:cached_network_image/cached_network_image.dart';
import 'package:doctors_app/data/appointment_records.dart';
import 'package:doctors_app/data/auth_data.dart';
import 'package:doctors_app/presentation/presentations.dart';
import 'package:doctors_app/screens/chat_screen.dart';
import 'package:doctors_app/screens/doctor_chat_screen.dart';
import 'package:doctors_app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class doc_chats extends StatefulWidget {
  static const id = "./doc_chats";
  @override
  State<doc_chats> createState() => _doc_chatsState();
}

class _doc_chatsState extends State<doc_chats> {
  Future? getDoctorChats;
  @override
  void initState() {
    final user = Provider.of<Auth>(context, listen: false).userId;
    getDoctorChats = Provider.of<appointment>(context, listen: false)
        .get_doc_appointments(user);
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<Auth>(context, listen: false).UserInfo;
    return Scaffold(
        drawer: drawer(),
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          backgroundColor: ColorManager.primery,
          toolbarHeight: MediaQuery.of(context).size.height * 0.08,
          title: Text(
            "Dr ${provider['username']!} Chats",
            style: getRegulerStyle(color: Colors.white, fontsize: 20),
          ),
        ),
        body: FutureBuilder(
            future: getDoctorChats,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              return Consumer<appointment>(
                  builder: (context, data, _) => Container(
                        padding: EdgeInsets.symmetric(vertical: 15),
                        child: data.doc_apps.isEmpty
                            ? Container(
                                color: Colors.white,
                                height: double.infinity,
                                width: double.infinity,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.7,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.3,
                                      child: Lottie.asset(
                                          'assets/json/empty.json',
                                          fit: BoxFit.contain),
                                    ),
                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.05,
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.7,
                                      child: Text(
                                        "You don't have any chats",
                                        textAlign: TextAlign.center,
                                        style: getMediumStyle(
                                            color: ColorManager.primery,
                                            fontsize: 18),
                                      ),
                                    )
                                  ],
                                ))
                            : ListView.builder(
                                itemCount: data.doc_apps.length,
                                itemBuilder: (context, index) {
                                  return Container(
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 15, vertical: 7),
                                    child: ListTile(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      textColor: ColorManager.white,
                                      tileColor:
                                          ColorManager.primery.withOpacity(0.9),
                                      trailing: Icon(
                                        Icons.arrow_forward,
                                        color: Colors.white,
                                      ),
                                      leading: CircleAvatar(
                                        radius:
                                            MediaQuery.of(context).size.height *
                                                0.025,
                                        backgroundColor: Colors.white,
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                              MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.025),
                                          child: CachedNetworkImage(
                                            imageUrl:
                                                data.doc_apps[index].userImage!,
                                            height: 100,
                                            width: 100,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      title: Text(
                                        data.doc_apps[index].username!,
                                        style: getRegulerStyle(
                                            color: Colors.white, fontsize: 17),
                                      ),
                                      onTap: () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (ctx) =>
                                                    doctor_chat_screen(
                                                        other_user_name: data
                                                            .doc_apps[index]
                                                            .username!,
                                                        other_user_id: data
                                                            .doc_apps[index]
                                                            .user_id!,
                                                        other_user_image: data
                                                            .doc_apps[index]
                                                            .userImage!)));
                                      },
                                    ),
                                  );
                                }),
                      ));
            }));
  }
}
