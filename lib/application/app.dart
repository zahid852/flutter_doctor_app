import 'dart:async';
import 'package:doctors_app/data/datas.dart';
import 'package:doctors_app/data/doc_cat_model.dart';
import 'package:doctors_app/data/doctor_messages.dart';
import 'package:doctors_app/data/messages.dart';
import 'package:doctors_app/presentation/presentations.dart';
import 'package:doctors_app/screens/appointment_screen.dart';
import 'package:doctors_app/screens/authentication_screen.dart';
import 'package:doctors_app/screens/chat_screen.dart';
import 'package:doctors_app/screens/doc_appointment_screen.dart';
import 'package:doctors_app/screens/doctor_chats.dart';
import 'package:doctors_app/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../screens/screens.dart';

class myApp extends StatefulWidget {
  myApp._internal();
  static final myApp instance = myApp._internal();
  factory myApp() => instance;

  @override
  State<myApp> createState() => _myAppState();
}

class _myAppState extends State<myApp> {
  Future future1() {
    return Future.delayed(Duration(milliseconds: 2500), () {});
  }

  Future future() {
    return Future.delayed(Duration(milliseconds: 2500), () {});
  }

  Future? prefs;
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => Auth(),
          ),
          ChangeNotifierProxyProvider<Auth, doc_cat_data>(
              create: (_) => doc_cat_data(),
              update: (ctx, auth, doc_cat_data) => doc_cat_data!..update(auth)),
          ChangeNotifierProxyProvider<Auth, doctor>(
              create: (_) => doctor(),
              update: (ctx, auth, doctor) =>
                  doctor!..update((auth.token ?? ''), (auth.userId))),
          ChangeNotifierProxyProvider<Auth, appointment>(
              create: (_) => appointment(),
              update: (ctx, auth, appointment) =>
                  appointment!..update((auth.token ?? ''), (auth.userId))),
          ChangeNotifierProxyProvider<Auth, MessageData>(
              create: (_) => MessageData(),
              update: (ctx, auth, message) =>
                  message!..update((auth.token ?? ''), (auth.userId))),
          ChangeNotifierProxyProvider<Auth, doc_messages>(
              create: (_) => doc_messages(),
              update: (ctx, auth, doc_message) =>
                  doc_message!..update((auth.token ?? ''), (auth.userId))),
        ],
        child: Consumer<Auth>(
            builder: ((context, auth_data, _) => MaterialApp(
                  debugShowCheckedModeBanner: false,
                  home: auth_data.isAuth()
                      ? (auth_data.alreadySigned == true
                          ? FutureBuilder(
                              future: future1(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Scaffold(
                                    appBar: AppBar(
                                      toolbarHeight: 0,
                                      backgroundColor: Colors.black,
                                    ),
                                    body: Container(
                                        color: Colors.white,
                                        height:
                                            MediaQuery.of(context).size.height,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: Center(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              SizedBox(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.2,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.5,
                                                child: Container(
                                                    child: Lottie.asset(
                                                        "assets/json/loading.json")),
                                              ),
                                              SizedBox(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.05,
                                              ),
                                              Container(
                                                child: Text(
                                                  'Loading...',
                                                  style: getMediumStyle(
                                                      color:
                                                          ColorManager.primery,
                                                      fontsize: 18),
                                                ),
                                              )
                                            ],
                                          ),
                                        )),
                                  );
                                } else {
                                  return nav_screen();
                                }
                              })
                          : nav_screen())
                      : FutureBuilder(
                          future: auth_data.autoLogIn(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Scaffold(
                                appBar: AppBar(
                                  toolbarHeight: 0,
                                  backgroundColor: Colors.black,
                                ),
                                body: Container(
                                  color: Colors.white,
                                ),
                              );
                            } else {
                              return FutureBuilder(
                                  future: future(),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return Scaffold(
                                        appBar: AppBar(
                                          toolbarHeight: 0,
                                          backgroundColor: Colors.black,
                                        ),
                                        body: Container(
                                            color: Colors.white,
                                            height: MediaQuery.of(context)
                                                .size
                                                .height,
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            child: Center(
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  SizedBox(
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.2,
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.5,
                                                    child: Container(
                                                        color: Colors.white,
                                                        child: Lottie.asset(
                                                            "assets/json/loading.json")),
                                                  ),
                                                  SizedBox(
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.05,
                                                  ),
                                                  Container(
                                                    child: Text(
                                                      'Loading...',
                                                      style: getMediumStyle(
                                                          color: ColorManager
                                                              .primery,
                                                          fontsize: 18),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            )),
                                      );
                                    } else {
                                      return nav_screen();
                                    }
                                  });
                            }
                          }),
                  routes: {
                    doc_cat.id: (ctx) => doc_cat(),
                    data_entry.id: (ctx) => data_entry(),
                    appointmentScreen.id: (ctx) => appointmentScreen(),
                    home_screen.id: (ctx) =>
                        home_screen(key: PageStorageKey('home-screen')),
                    doc_chats.id: ((ctx) => doc_chats()),
                    doc_appointment_screen.id: ((ctx) =>
                        doc_appointment_screen()),
                  },
                ))));
  }
}
