import 'package:doctors_app/data/appointment_records.dart';
import 'package:doctors_app/data/auth_data.dart';
import 'package:doctors_app/presentation/color_manager.dart';
import 'package:doctors_app/presentation/styles_manager.dart';
import 'package:doctors_app/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class doc_appointment_screen extends StatefulWidget {
  static const id = "./doc_appointment";

  @override
  State<doc_appointment_screen> createState() => _doc_appointment_screenState();
}

class _doc_appointment_screenState extends State<doc_appointment_screen> {
  Future? user_data;
  String? login_user;

  List<doc_appointment_model> today_appointment = [];
  List<doc_appointment_model> prev_appointment = [];

  DateTime now = DateTime.now();
  List<Widget> today_widgets = [];
  DateTime? date;
  int diffInHourse = 0;
  String? end_of_string;

  @override
  void initState() {
    login_user = Provider.of<Auth>(context, listen: false).userId;
    user_data = Provider.of<appointment>(context, listen: false)
        .get_doctor_appointments(login_user!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: drawer(),
      appBar: AppBar(
        backgroundColor: ColorManager.primery,
        centerTitle: true,
        elevation: 0,
        toolbarHeight: MediaQuery.of(context).size.height * 0.08,
        title: Text('Your Record'),
      ),
      body: FutureBuilder(
          future: user_data,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return Consumer<appointment>(builder: ((context, data, _) {
              if (data.doctor_apps.isEmpty) {
                return Container(
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
                          height: MediaQuery.of(context).size.height * 0.3,
                          child: Lottie.asset('assets/json/empty.json',
                              fit: BoxFit.contain),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.05,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.7,
                          child: Text(
                            'You had no appointments.',
                            textAlign: TextAlign.center,
                            style: getMediumStyle(
                                color: ColorManager.primery, fontsize: 18),
                          ),
                        )
                      ],
                    ));
              }
              data.doctor_apps.forEach(
                (_appointment) {
                  date = _appointment.time;
                  diffInHourse = now.difference(date!).inHours;
                  if (diffInHourse < 24) {
                    today_appointment.add(_appointment);
                  } else {
                    prev_appointment.add(_appointment);
                  }
                },
              );
              return Container(
                  height: double.infinity,
                  color: Colors.grey[300],
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          alignment: Alignment.centerLeft,
                          margin:
                              EdgeInsets.only(top: 15, bottom: 10, left: 10),
                          child: Text(
                            "Today's Appointment",
                            style: getBoldStyle(
                                color: ColorManager.primery, fontsize: 20),
                          ),
                        ),
                        Column(
                          children: getList(today_appointment),
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          margin:
                              EdgeInsets.only(top: 15, bottom: 10, left: 10),
                          child: Text(
                            "Previous Appointment(s)",
                            style: getBoldStyle(
                                color: ColorManager.primery, fontsize: 20),
                          ),
                        ),
                        Column(
                          children: getList(prev_appointment),
                        ),
                      ],
                    ),
                  ));
            }));
          }),
    );
  }

  List<Widget> getList(List<doc_appointment_model> appointments) {
    today_widgets = appointments.map((appointment) {
      end_of_string = appointments == prev_appointment
          ? 'on ${DateFormat('dd-MM-yyyy hh:mm a').format(appointment.time)}'
          : 'today';
      String grammer = appointments == prev_appointment ? 'had' : 'have';
      return Container(
          margin: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
          child: Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)),
              child: Container(
                margin: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                child: Text(
                  "You ${grammer} appointment with ${appointment.patient_name} ${end_of_string}",
                  style: getRegulerStyle(color: Colors.black, fontsize: 16),
                ),
              )));
    }).toList();

    if (appointments == today_appointment && today_widgets.length == 0) {
      return today_widgets = [
        Container(
            margin: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
            child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
                child: Container(
                  margin: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                  child: Text(
                    "You have no appointment(s) today",
                    style: getRegulerStyle(color: Colors.black, fontsize: 16),
                  ),
                )))
      ];
    }
    if (appointments == prev_appointment && today_widgets.length == 0) {
      return today_widgets = [
        Container(
            margin: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
            child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
                child: Container(
                  margin: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                  child: Text(
                    "You had no appointments previously",
                    style: getRegulerStyle(color: Colors.black, fontsize: 16),
                  ),
                )))
      ];
    }

    return today_widgets;
  }
}
