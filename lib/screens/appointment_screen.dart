import 'package:doctors_app/data/appointment_records.dart';
import 'package:doctors_app/data/auth_data.dart';
import 'package:doctors_app/presentation/color_manager.dart';
import 'package:doctors_app/presentation/presentations.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class appointmentScreen extends StatefulWidget {
  static const String id = './appointent_Screen';
  @override
  State<appointmentScreen> createState() => _appointmentScreenState();
}

class _appointmentScreenState extends State<appointmentScreen> {
  Future? user_data;
  String? end_of_string;
  String? grammer;

  @override
  void initState() {
    user_data = Provider.of<appointment>(context, listen: false).get_data();

    super.initState();
  }

  List<appointment_model> today_appointment = [];
  List<appointment_model> prev_appointment = [];
  DateTime now = DateTime.now();
  List<Widget> today_widgets = [];
  DateTime? date;
  int diffInHourse = 0;
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<Auth>(context, listen: false).UserInfo;
    return Scaffold(
      appBar: AppBar(
          backgroundColor: ColorManager.primery,
          centerTitle: true,
          elevation: 0,
          toolbarHeight: MediaQuery.of(context).size.height * 0.08,
          title: Text("Your Record")),
      body: FutureBuilder(
          future: user_data,
          builder: (context, snapshot) {
            if (ConnectionState.waiting == snapshot.connectionState) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return Consumer<appointment>(builder: (context, data, _) {
                data.app_items.forEach(
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
              });
            }
          }),
    );
  }

  List<Widget> getList(List<appointment_model> appointments) {
    today_widgets = appointments.map((appointment) {
      end_of_string = appointments == prev_appointment
          ? 'on ${DateFormat('dd-MM-yyyy').format(appointment.time)}'
          : 'today';
      grammer = appointments == prev_appointment ? 'had' : 'have';
      return Container(
          margin: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
          child: Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)),
              child: Container(
                margin: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                child: Text(
                  "You ${grammer} appointment with ${appointment.cat} Dr.${appointment.doc_name} ${end_of_string}",
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
                    "You made no appointment(s) today",
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
