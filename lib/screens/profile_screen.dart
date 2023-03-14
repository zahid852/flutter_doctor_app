import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:doctors_app/data/datas.dart';
import 'package:doctors_app/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;

import '../presentation/presentations.dart';

class profile_doctor extends StatefulWidget {
  final doctor_model doctor;
  final doc_extra_details? extra_data;
  profile_doctor({required this.doctor, this.extra_data});

  @override
  State<profile_doctor> createState() => _profile_doctorState();
}

class _profile_doctorState extends State<profile_doctor> {
  bool isSaving = false;

  String today = DateFormat('EEEE').format(DateTime.now());
  int leave = 0;
  @override
  void initState() {
    widget.doctor.working_days.forEach((key, value) {
      if (today.toLowerCase() == key.toLowerCase()) {
        if (value == "leave") {
          leave = 1;
        }
      }
    });
    // TODO: implement initState
    super.initState();
  }

  Widget timeTable(context, day, time) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.3,
                child: Text(
                  day,
                  style: getRegulerStyle(color: Colors.black, fontsize: 16),
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.1,
              ),
              Text(
                '${time} ',
                style: getRegulerStyle(color: Colors.black, fontsize: 16),
              ),
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Divider()
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<Auth>(context, listen: false).UserInfo;
    Map<String, dynamic> doctor_timeTable = widget.doctor.working_days;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorManager.primery,
        centerTitle: true,
        toolbarHeight: MediaQuery.of(context).size.height * 0.08,
        title: Text('Doctor Profile'),
      ),
      body: Container(
        color: Colors.grey[350],
        child: Column(
          children: [
            Expanded(
                child: SingleChildScrollView(
              child: Container(
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.fromLTRB(5, 5, 5, 2),
                      child: Card(
                        elevation: 2,
                        child: Container(
                          color: Colors.white,
                          padding: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          child: Row(
                            children: [
                              widget.extra_data == null
                                  ? Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.15,
                                      width: MediaQuery.of(context).size.width *
                                          0.3,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.grey,
                                          image: DecorationImage(
                                              fit: BoxFit.cover,
                                              image: AssetImage(
                                                'assets/images/doctor.jpg',
                                              ))),
                                    )
                                  : Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.15,
                                      width: MediaQuery.of(context).size.width *
                                          0.3,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.grey),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(
                                            MediaQuery.of(context).size.height *
                                                0.15),
                                        child: CachedNetworkImage(
                                          imageUrl: widget.extra_data!.image,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.07,
                              ),
                              Expanded(
                                  child: Container(
                                color: Colors.white,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Name :',
                                      style: getRegulerStyle(
                                          color: Colors.black, fontsize: 18),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      'Dr. ${widget.doctor.name}',
                                      style: getMediumStyle(
                                          color: ColorManager.primery,
                                          fontsize: 18),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      'Experience :',
                                      style: getRegulerStyle(
                                          color: Colors.black, fontsize: 18),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      '${widget.doctor.experience}',
                                      style: getMediumStyle(
                                          color: ColorManager.primery,
                                          fontsize: 18),
                                    ),
                                  ],
                                ),
                              ))
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10)),
                      ),
                      child: Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                        )),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                  decoration: BoxDecoration(
                                    color: ColorManager.primery,
                                  ),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 8),
                                  alignment: Alignment.centerLeft,
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.email,
                                        color: Colors.white,
                                        size: 18,
                                      ),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.02,
                                      ),
                                      Text(
                                        'Email Address',
                                        style: getRegulerStyle(
                                            color: Colors.white, fontsize: 18),
                                      ),
                                    ],
                                  )),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(10),
                                      bottomRight: Radius.circular(10)),
                                ),
                                padding: EdgeInsets.symmetric(
                                    vertical: 15, horizontal: 10),
                                child: Text(
                                  '${widget.doctor.email}',
                                  style: getRegulerStyle(
                                      color: Colors.black, fontsize: 18),
                                ),
                              )
                            ]),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10)),
                      ),
                      child: Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                        )),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                  decoration: BoxDecoration(
                                    color: ColorManager.primery,
                                  ),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 8),
                                  alignment: Alignment.centerLeft,
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.location_city,
                                        color: Colors.white,
                                        size: 18,
                                      ),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.02,
                                      ),
                                      Text(
                                        'Practice Location',
                                        style: getRegulerStyle(
                                            color: Colors.white, fontsize: 18),
                                      ),
                                    ],
                                  )),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(10),
                                      bottomRight: Radius.circular(10)),
                                ),
                                padding: EdgeInsets.symmetric(
                                    vertical: 15, horizontal: 10),
                                child: Text(
                                  '${widget.doctor.practice_location}',
                                  style: getRegulerStyle(
                                      color: Colors.black, fontsize: 18),
                                ),
                              )
                            ]),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10)),
                      ),
                      child: Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                        )),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                  decoration: BoxDecoration(
                                    color: ColorManager.primery,
                                  ),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 8),
                                  alignment: Alignment.centerLeft,
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.money,
                                        color: Colors.white,
                                        size: 18,
                                      ),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.02,
                                      ),
                                      Text(
                                        "Doctor's Fee",
                                        style: getRegulerStyle(
                                            color: Colors.white, fontsize: 18),
                                      ),
                                    ],
                                  )),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(10),
                                      bottomRight: Radius.circular(10)),
                                ),
                                padding: EdgeInsets.symmetric(
                                    vertical: 15, horizontal: 10),
                                child: Text(
                                  '${widget.doctor.fees} Rs.',
                                  style: getRegulerStyle(
                                      color: Colors.green, fontsize: 18),
                                ),
                              )
                            ]),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10)),
                      ),
                      child: Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                        )),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                  decoration: BoxDecoration(
                                    color: ColorManager.primery,
                                  ),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 8),
                                  alignment: Alignment.centerLeft,
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.description,
                                        color: Colors.white,
                                        size: 18,
                                      ),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.02,
                                      ),
                                      Text(
                                        "About",
                                        style: getRegulerStyle(
                                            color: Colors.white, fontsize: 18),
                                      ),
                                    ],
                                  )),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(10),
                                      bottomRight: Radius.circular(10)),
                                ),
                                padding: EdgeInsets.symmetric(
                                    vertical: 15, horizontal: 10),
                                child: Text(
                                  '${widget.doctor.about}',
                                  style: getRegulerStyle(
                                      color: Colors.black, fontsize: 17),
                                ),
                              )
                            ]),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10)),
                      ),
                      child: Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                        )),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                  decoration: BoxDecoration(
                                    color: ColorManager.primery,
                                  ),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 8),
                                  alignment: Alignment.centerLeft,
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.schedule,
                                        color: Colors.white,
                                        size: 18,
                                      ),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.02,
                                      ),
                                      Text(
                                        "Doctor's Timing",
                                        style: getRegulerStyle(
                                            color: Colors.white, fontsize: 18),
                                      ),
                                    ],
                                  )),
                              Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(10),
                                        bottomRight: Radius.circular(10)),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 10),
                                  child: Column(
                                    children: [
                                      Divider(),
                                      timeTable(context, 'Monday',
                                          widget.doctor.working_days['monday']),
                                      timeTable(
                                          context,
                                          'Tuesday',
                                          widget
                                              .doctor.working_days['tuesday']),
                                      timeTable(
                                          context,
                                          'Wednesday',
                                          widget.doctor
                                              .working_days['wednesday']),
                                      timeTable(
                                          context,
                                          'Thursday',
                                          widget
                                              .doctor.working_days['thursday']),
                                      timeTable(context, 'Friday',
                                          widget.doctor.working_days['friday']),
                                      timeTable(
                                          context,
                                          'Saturday',
                                          widget
                                              .doctor.working_days['saturday']),
                                      timeTable(context, 'Sunday',
                                          widget.doctor.working_days['sunday']),
                                    ],
                                  ))
                            ]),
                      ),
                    )
                  ],
                ),
              ),
            )),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.005,
            ),
            if (provider['type'] == 'User')
              Container(
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.fromLTRB(10, 10, 10, 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            flex: 1,
                            child: Container(
                              decoration: BoxDecoration(
                                  color: ColorManager.primery,
                                  borderRadius: BorderRadius.circular(6)),
                              child: TextButton.icon(
                                  onPressed: () {
                                    // ignore: deprecated_member_use
                                    UrlLauncher.launch(
                                        "tel://${widget.doctor.phone}");
                                  },
                                  icon: Icon(
                                    Icons.call,
                                    color: ColorManager.white,
                                  ),
                                  label: Text(
                                    'Call',
                                    style: getRegulerStyle(
                                        color: ColorManager.white,
                                        fontsize: 16),
                                  )),
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.05,
                          ),
                          Expanded(
                            flex: 1,
                            child: Container(
                              decoration: BoxDecoration(
                                  color: widget.extra_data == null || leave == 1
                                      ? Colors.grey
                                      : ColorManager.primery,
                                  borderRadius: BorderRadius.circular(6)),
                              child: TextButton.icon(
                                  onPressed: () {
                                    widget.extra_data == null
                                        ? getDialog(
                                            "assets/json/not_found.json",
                                            "Sorry!",
                                            'The doctor will be available soon',
                                            "no")
                                        : (leave == 1
                                            ? getDialog(
                                                "assets/json/not_found.json",
                                                "Sorry!",
                                                'The doctor is on leave today.',
                                                "no")
                                            : Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (ctx) =>
                                                        chat_screen(
                                                            doctor:
                                                                widget.doctor,
                                                            extra_data: widget
                                                                .extra_data!))));
                                  },
                                  icon: Icon(
                                    Icons.message,
                                    color:
                                        widget.extra_data == null || leave == 1
                                            ? Colors.white
                                            : ColorManager.white,
                                  ),
                                  label: Text(
                                    'Message',
                                    style: getRegulerStyle(
                                        color: widget.extra_data == null ||
                                                leave == 1
                                            ? Colors.white
                                            : ColorManager.white,
                                        fontsize: 16),
                                  )),
                            ),
                          ),
                        ],
                      ),
                    ),
                    isSaving
                        ? Container(
                            margin: EdgeInsets.fromLTRB(5, 0, 5, 5),
                            height: MediaQuery.of(context).size.height * 0.1,
                            child: Center(
                              child: CircularProgressIndicator(
                                color: ColorManager.primery,
                              ),
                            ),
                          )
                        : GestureDetector(
                            onTap: () {
                              widget.extra_data == null
                                  ? getDialog(
                                      "assets/json/not_found.json",
                                      "Sorry!",
                                      'The doctor will be available',
                                      "no")
                                  : (leave == 1
                                      ? getDialog(
                                          "assets/json/not_found.json",
                                          "Sorry!",
                                          'The doctor is on leave today.',
                                          "no")
                                      : getAppointment(
                                          doctor_timeTable, context));
                            },
                            child: Container(
                              height: MediaQuery.of(context).size.height * 0.1,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(6)),
                              margin: EdgeInsets.fromLTRB(5, 0, 5, 5),
                              child: Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6)),
                                elevation:
                                    widget.extra_data == null || leave == 1
                                        ? 0
                                        : 3,
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: widget.extra_data == null ||
                                              leave == 1
                                          ? Colors.grey
                                          : Colors.yellow,
                                      borderRadius: BorderRadius.circular(6)),
                                  height: double.infinity,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 5),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.schedule,
                                        color: widget.extra_data == null ||
                                                leave == 1
                                            ? Colors.white
                                            : ColorManager.primery,
                                      ),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.04,
                                      ),
                                      Text('Book Appointment',
                                          style: getRegulerStyle(
                                              color:
                                                  widget.extra_data == null ||
                                                          leave == 1
                                                      ? Colors.white
                                                      : ColorManager.primery,
                                              fontsize: 16))
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                  ],
                ),
              )
          ],
        ),
      ),
    );
  }

  getAppointment(Map<String, dynamic> timeTable, BuildContext context) async {
    int NoAppointment = 0;

    var date = DateTime.now();
    String today = DateFormat('EEEE').format(date);

    timeTable.forEach((key, value) {
      if (today.toLowerCase() == key.toLowerCase()) {
        if (value == "leave") {
          NoAppointment = 1;
        }
      }
    });
    if (NoAppointment == 0) {
      setState(() {
        isSaving = true;
      });
      bool response = await Provider.of<appointment>(context, listen: false)
          .add_app(
              appointment_model(
                  doc_name: widget.doctor.name,
                  cat: widget.doctor.dis_cat,
                  time: DateTime.now()),
              widget.doctor.email);
      setState(() {
        isSaving = false;
      });
      if (response == true) {
        getDialog("assets/json/success_case.json", "Congratulations",
            'You have booked your appointment for today.', "ok");
      } else {
        getDialog("assets/json/repeat.json", "Alert",
            'You have already booked your appointment for today.', "ok");
      }
    } else {
      getDialog("assets/json/not_found.json", "Sorry!",
          'The doctor is on leave today.', "no");
    }
  }

  getDialog(String lotie, String status, String message, String result) {
    return showDialog(
        context: context,
        builder: (context) {
          return Dialog(
              backgroundColor: Colors.transparent,
              child: Container(
                  padding: EdgeInsets.fromLTRB(20, 0, 20, 10),
                  decoration: BoxDecoration(
                    color: ColorManager.white,
                    // boxShadow: [
                    //   BoxShadow(
                    //       color: Colors.black12,
                    //       blurRadius: appSize.s12,
                    //       offset: Offset(0, 14))
                    // ],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height * 0.225,
                        child: Stack(children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.2,
                            width: MediaQuery.of(context).size.width * 0.5,
                            child: Container(child: Lottie.asset(lotie)),
                          ),
                          Positioned(
                            bottom: 0,
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.5,
                              alignment: Alignment.center,
                              child: Text(
                                status,
                                style: getBoldStyle(
                                    color: result == "ok"
                                        ? ColorManager.primery
                                        : Colors.red,
                                    fontsize: 20),
                              ),
                            ),
                          ),
                        ]),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.02,
                      ),
                      Container(
                        // padding: EdgeInsets.symmetric(horizontal: 20),
                        width: double.infinity,
                        alignment: Alignment.center,
                        child: Text(
                          message,
                          textAlign: TextAlign.center,
                          style: getRegulerStyle(
                              color: ColorManager.primery, fontsize: 16),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.03,
                      ),
                      Container(
                        width: double.infinity,
                        alignment: Alignment.centerRight,
                        child: TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              "OK",
                              style: getRegulerStyle(
                                  color: ColorManager.primery, fontsize: 18),
                            )),
                      )
                    ],
                  )));
        });
  }
}
