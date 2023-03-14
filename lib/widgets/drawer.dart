import 'package:doctors_app/data/auth_data.dart';
import 'package:doctors_app/data/doctor_model.dart';
import 'package:doctors_app/presentation/presentations.dart';
import 'package:doctors_app/screens/appointment_screen.dart';
import 'package:doctors_app/screens/authentication_screen.dart';
import 'package:doctors_app/screens/doc_appointment_screen.dart';
import 'package:doctors_app/screens/doc_category.dart';
import 'package:doctors_app/screens/doctor_chat_screen.dart';
import 'package:doctors_app/screens/doctor_chats.dart';
import 'package:doctors_app/screens/home_screen.dart';
import 'package:doctors_app/screens/screens.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class drawer extends StatefulWidget {
  @override
  State<drawer> createState() => _drawerState();
}

class _drawerState extends State<drawer> {
  lt(BuildContext context, IconData icon, String text, String id) {
    return Column(
      children: [
        Container(
          height: MediaQuery.of(context).size.height * 0.08,
          alignment: Alignment.center,
          child: ListTile(
            leading: Icon(
              icon,
              color: ColorManager.primery,
            ),
            title: Text(
              text,
              style: getMediumStyle(color: ColorManager.primery, fontsize: 17),
            ),
            onTap: () {
              if (text == "Logout") {
                Navigator.of(context).pushNamedAndRemoveUntil(
                    '/', (Route<dynamic> route) => false);
                Provider.of<Auth>(context, listen: false).logout();
              } else if (ModalRoute.of(context)!.settings.name == id) {
                Navigator.of(context).pop();
              } else {
                Navigator.of(context).pushReplacementNamed(id);
              }
            },
          ),
        ),
        Divider(
          height: 5,
          color: ColorManager.primery,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<Auth>(context, listen: false).UserInfo;
    return Drawer(
      child: Column(
        children: [
          Container(
              color: ColorManager.primery,
              width: double.infinity,
              child: Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.04,
                  ),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                    alignment: Alignment.centerLeft,
                    child: CircleAvatar(
                      // backgroundColor: Colors.white,
                      radius: MediaQuery.of(context).size.height * 0.08,
                      backgroundColor: Colors.white,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(
                            MediaQuery.of(context).size.height * 0.08),
                        child: Image.network(
                          provider['url'] ??
                              'https://images.unsplash.com/photo-1511367461989-f85a21fda167?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MXx8cHJvZmlsZXxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=500&q=60',
                          height: double.infinity,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.011,
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.only(left: 40),
                    child: Text(provider['username']!,
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeightManager.reguler,
                            fontSize: 17,
                            letterSpacing: 1.2)),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.01,
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.only(left: 40),
                    child: Text(provider['email']!,
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeightManager.reguler,
                            fontSize: 17,
                            letterSpacing: 1.2)),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.04,
                  ),
                ],
              )),
          if (provider['type'] == 'Admin')
            Column(
              children: [
                lt(context, Icons.home, 'Home', home_screen.id),
                lt(context, Icons.add, 'Add Doctor', data_entry.id),
                lt(context, Icons.category, 'Add Category', doc_cat.id),
              ],
            ),
          if (provider['type'] == 'Doctor')
            Column(
              children: [
                lt(context, Icons.home, 'Home', home_screen.id),
                lt(context, Icons.add, 'Notifications', doc_chats.id),
                lt(context, Icons.menu, 'Appointments',
                    doc_appointment_screen.id),
              ],
            ),
          lt(context, Icons.logout, 'Logout', ''),
        ],
      ),
    );
  }
}
