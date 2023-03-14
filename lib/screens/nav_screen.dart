import 'package:doctors_app/data/auth_data.dart';
import 'package:doctors_app/presentation/color_manager.dart';
import 'package:doctors_app/presentation/presentations.dart';
import 'package:doctors_app/screens/appointment_screen.dart';
import 'package:doctors_app/screens/screens.dart';
import 'package:doctors_app/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class nav_screen extends StatefulWidget {
  @override
  State<nav_screen> createState() => _nav_screenState();
}

class _nav_screenState extends State<nav_screen> {
  final List<Widget> screens = [
    home_screen(key: PageStorageKey('home-screen')),
    appointmentScreen(),
  ];
  final Map<String, IconData> icons = {
    'Home': Icons.home,
    'Appointments': Icons.menu,
    // 'Medical Record': Icons.medical_services,
  };
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<Auth>(context, listen: false).UserInfo;
    print('login type ${provider['type']}');
    return Scaffold(
      drawer: drawer(),
      body: screens[currentIndex],
      bottomNavigationBar:
          (provider['type'] == "Admin" || provider['type'] == 'Doctor')
              ? null
              : BottomNavigationBar(
                  items: icons
                      .map((title, icon) => MapEntry(
                          title,
                          BottomNavigationBarItem(
                            icon: Icon(
                              icon,
                              size: 30,
                            ),
                            label: title,
                          )))
                      .values
                      .toList(),
                  currentIndex: currentIndex,
                  selectedItemColor: ColorManager.primery,
                  type: BottomNavigationBarType.shifting,
                  selectedFontSize: 17,
                  unselectedItemColor: Colors.black54,
                  unselectedFontSize: 15,
                  onTap: (index) => setState(() {
                    currentIndex = index;
                  }),
                ),
    );
  }
}
