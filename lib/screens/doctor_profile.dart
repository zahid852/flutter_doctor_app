import 'package:cached_network_image/cached_network_image.dart';
import 'package:doctors_app/data/datas.dart';
import 'package:doctors_app/presentation/color_manager.dart';
import 'package:doctors_app/presentation/presentations.dart';
import 'package:doctors_app/screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;

class profile extends StatefulWidget {
  final List<doctor_model> doc;
  final String cat;
  final List<doc_extra_details> extra_details;

  profile({required this.doc, required this.cat, required this.extra_details});

  @override
  State<profile> createState() => _profileState();
}

class _profileState extends State<profile> {
  bool isSaving = false;
  String? doctor_loading_id = null;
  doc_extra_details? extra_data;
  int leave = 0;
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<Auth>(context, listen: false).UserInfo;
    return Scaffold(
      backgroundColor: Colors.grey[350],
      appBar: AppBar(
        backgroundColor: ColorManager.primery,
        toolbarHeight: MediaQuery.of(context).size.height * 0.1,
        elevation: 0,
        centerTitle: true,
        title: Text(widget.cat),
      ),
      body: widget.doc.isEmpty
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
                    width: MediaQuery.of(context).size.width * 0.7,
                    height: MediaQuery.of(context).size.width * 0.8,
                    child: Lottie.asset('assets/json/soon.json',
                        fit: BoxFit.cover),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.05,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: Text(
                      'The doctor will be added soon!',
                      textAlign: TextAlign.center,
                      style: getMediumStyle(
                          color: ColorManager.primery, fontsize: 18),
                    ),
                  )
                ],
              ))
          : ListView.builder(
              physics: BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              itemCount: widget.doc.length,
              itemBuilder: (context, index) {
                extra_data = null;
                widget.extra_details.forEach((detail) {
                  if (detail.email == widget.doc[index].email) {
                    extra_data = detail;
                  }
                });

                leave = 0;
                var date = DateTime.now();
                String today = DateFormat('EEEE').format(date);
                widget.doc[index].working_days.forEach((key, value) {
                  if (today.toLowerCase() == key.toLowerCase()) {
                    if (value == "leave") {
                      leave = 1;
                    }
                  }
                });

                return Container(
                  height: MediaQuery.of(context).size.height * 0.275,
                  margin: EdgeInsets.only(bottom: 5),
                  width: double.infinity,
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    elevation: 5,
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15)),
                          padding: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          child: Row(
                            children: [
                              extra_data == null
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
                                          imageUrl: extra_data!.image,
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
                                          color: Colors.black, fontsize: 14),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      'Dr. ${widget.doc[index].name}',
                                      style: getMediumStyle(
                                          color: ColorManager.primery,
                                          fontsize: 16),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      'Experience :',
                                      style: getRegulerStyle(
                                          color: Colors.black, fontsize: 13),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      '${widget.doc[index].experience}',
                                      style: getMediumStyle(
                                          color: ColorManager.primery,
                                          fontsize: 16),
                                    ),
                                  ],
                                ),
                              ))
                            ],
                          ),
                        ),
                        Expanded(
                            child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6)),
                          margin: EdgeInsets.fromLTRB(10, 3, 10, 15),
                          child: provider['type'] == 'Admin' ||
                                  provider['type'] == 'Doctor'
                              ? Card(
                                  elevation: 5,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(6)),
                                  child: Container(
                                    height: double.infinity,
                                    decoration: BoxDecoration(
                                        color: ColorManager.primery,
                                        borderRadius: BorderRadius.circular(6)),
                                    child: TextButton(
                                      onPressed: () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    profile_doctor(
                                                      doctor: widget.doc[index],
                                                      extra_data: extra_data,
                                                    )));
                                      },
                                      child: Text('Profile',
                                          style: getRegulerStyle(
                                              color: ColorManager.white,
                                              fontsize: 16)),
                                    ),
                                  ))
                              : Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) {
                                          extra_data = null;
                                          widget.extra_details
                                              .forEach((detail) {
                                            if (detail.email ==
                                                widget.doc[index].email) {
                                              extra_data = detail;
                                            }
                                          });
                                          return profile_doctor(
                                            doctor: widget.doc[index],
                                            extra_data: extra_data == null
                                                ? null
                                                : extra_data,
                                          );
                                        }));
                                      },
                                      child: Card(
                                        elevation: 5,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(6)),
                                        child: Container(
                                          height: double.infinity,
                                          decoration: BoxDecoration(
                                              color: ColorManager.primery,
                                              borderRadius:
                                                  BorderRadius.circular(6)),
                                          padding:
                                              EdgeInsets.fromLTRB(10, 5, 20, 5),
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.person,
                                                color: ColorManager.white,
                                                size: 16,
                                              ),
                                              SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.015,
                                              ),
                                              Text('Profile',
                                                  style: getRegulerStyle(
                                                      color: ColorManager.white,
                                                      fontsize: 15))
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: () {
                                          extra_data = null;
                                          widget.extra_details
                                              .forEach((detail) {
                                            if (detail.email ==
                                                widget.doc[index].email) {
                                              extra_data = detail;
                                            }
                                          });
                                          leave = 0;
                                          widget.doc[index].working_days
                                              .forEach((key, value) {
                                            if (today.toLowerCase() ==
                                                key.toLowerCase()) {
                                              if (value == "leave") {
                                                leave = 1;
                                              }
                                            }
                                          });
                                          extra_data == null
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
                                                  : getAppointment(
                                                      widget.doc[index],
                                                      widget.doc[index]
                                                          .working_days,
                                                      context));
                                        },
                                        child: isSaving &&
                                                widget.doc[index].id ==
                                                    doctor_loading_id
                                            ? Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              )
                                            : (Container(
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            6)),
                                                margin:
                                                    EdgeInsets.only(left: 10),
                                                child: Card(
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              6)),
                                                  elevation:
                                                      extra_data == null ||
                                                              leave == 1
                                                          ? 0
                                                          : 2,
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                        color: extra_data ==
                                                                    null ||
                                                                leave == 1
                                                            ? Colors.grey
                                                            : Colors.yellow,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(6)),
                                                    height: double.infinity,
                                                    // padding:
                                                    //     EdgeInsets.symmetric(
                                                    //         horizontal: 12,
                                                    //         vertical: 5),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Icon(
                                                          Icons.schedule,
                                                          size: 20,
                                                          color: extra_data ==
                                                                      null ||
                                                                  leave == 1
                                                              ? Colors.white
                                                              : ColorManager
                                                                  .primery,
                                                        ),
                                                        SizedBox(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.02,
                                                        ),
                                                        Text('Book Appointment',
                                                            style: getRegulerStyle(
                                                                color: extra_data ==
                                                                            null ||
                                                                        leave ==
                                                                            1
                                                                    ? ColorManager
                                                                        .white
                                                                    : ColorManager
                                                                        .primery,
                                                                fontsize: 15))
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              )),
                                      ),
                                    )
                                  ],
                                ),
                        ))
                      ],
                    ),
                  ),
                );
              }),
    );
  }

  getAppointment(doctor_model doctor, Map<String, dynamic> timeTable,
      BuildContext context) async {
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
        doctor_loading_id = doctor.id;
      });
      bool response =
          await Provider.of<appointment>(context, listen: false).add_app(
              appointment_model(
                doc_name: doctor.name,
                cat: doctor.dis_cat,
                time: DateTime.now(),
              ),
              doctor.email);

      if (response == true) {
        getDialog("assets/json/success_case.json", "Congratulations",
            'You have booked your appointment for today.', "ok");
      } else {
        getDialog("assets/json/repeat.json", "Alert",
            'You have already booked your appointment for today.', "ok");
      }
      setState(() {
        isSaving = false;
        doctor_loading_id = null;
      });
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
