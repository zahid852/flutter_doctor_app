import 'package:doctors_app/data/doc_cat_model.dart';
import 'package:doctors_app/data/doctor_model.dart';
import 'package:doctors_app/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../presentation/presentations.dart';

class data_entry extends StatefulWidget {
  static const id = './data_entry';
  @override
  State<data_entry> createState() => _data_entryState();
}

class _data_entryState extends State<data_entry> {
  Future? data;
  String? val;
  double year = 0;
  double months = 0;
  String exp = '';
  bool isSaving = false;
  List<doc_cat_model> category_data = [];
  @override
  void initState() {
    data = Provider.of<doc_cat_data>(context, listen: false).get_data('');
    // TODO: implement initState
    super.initState();
  }

  doctor_model dcm = doctor_model(
    name: '',
    email: '',
    experience: '',
    practice_location: '',
    fees: 0,
    about: '',
    dis_cat: '',
    phone: '',
    working_days: {
      'Monday': null,
      'Tuesday': null,
      'Wednesday': null,
      'Thursday': null,
      'Friday': null,
      'Saturday': null,
      'Sunday': null,
    },
  );
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        // appBar: AppBar(
        //   toolbarHeight: MediaQuery.of(context).size.height * 0.08,
        //   backgroundColor: ColorManager.primery,
        //   centerTitle: getApplicationTheme().appBarTheme.centerTitle,
        //   title: Text(
        //     'DoctorZone',
        //     style: getApplicationTheme().appBarTheme.titleTextStyle,
        //   ),
        // ),
        drawer: drawer(),
        body: Column(
          children: [
            Container(
              alignment: Alignment.centerLeft,
              height: MediaQuery.of(context).size.height * 0.24,
              color: ColorManager.primery,
              child: SafeArea(
                child: Column(
                  children: [
                    Container(
                        height: MediaQuery.of(context).size.height * 0.1,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.04,
                            ),
                            GestureDetector(
                              onTap: () =>
                                  _scaffoldKey.currentState!.openDrawer(),
                              child: Icon(
                                Icons.menu,
                                color: Colors.white,
                                size: 25,
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.235,
                            ),
                            Text(
                              'DoctorZone',
                              style: getRegulerStyle(
                                  color: Colors.white, fontsize: 24),
                            )
                          ],
                        )),
                    Container(
                      padding: EdgeInsets.only(left: 30),
                      height: MediaQuery.of(context).size.height * 0.1,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Add Doctor',
                        style:
                            getRegulerStyle(color: Colors.white, fontsize: 24),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Expanded(
                child: FutureBuilder(
                    future: data,
                    builder: (cont, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      return Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                            horizontal: appPadding.p16,
                            vertical: appPadding.p16),
                        height: double.infinity,
                        color: Colors.white,
                        child: SingleChildScrollView(
                          physics: BouncingScrollPhysics(),
                          child: Column(
                            children: [
                              Form(
                                  key: _formKey,
                                  child: SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          height: 10,
                                        ),
                                        TextFormField(
                                          inputFormatters: [
                                            FilteringTextInputFormatter.deny(
                                                RegExp('[0-9.,]'))
                                          ],
                                          decoration: InputDecoration(
                                              prefixIcon: Icon(Icons.person),
                                              border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          appSize.s16)),
                                              labelText: 'Name of the doctor'),
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return 'Enter doctor name';
                                            }
                                          },
                                          onSaved: (value) {
                                            dcm = doctor_model(
                                                name: value.toString(),
                                                email: dcm.email,
                                                experience: dcm.experience,
                                                practice_location:
                                                    dcm.practice_location,
                                                fees: dcm.fees,
                                                about: dcm.about,
                                                dis_cat: dcm.dis_cat,
                                                phone: dcm.phone,
                                                working_days: dcm.working_days);
                                          },
                                        ),
                                        SizedBox(
                                          height: appSize.s18,
                                        ),
                                        TextFormField(
                                          keyboardType:
                                              TextInputType.emailAddress,
                                          decoration: InputDecoration(
                                              prefixIcon: Icon(Icons.email),
                                              border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          appSize.s16)),
                                              labelText: 'Email Address'),
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return 'Enter email address';
                                            }
                                          },
                                          onSaved: (value) {
                                            dcm = doctor_model(
                                                name: dcm.name,
                                                email: value.toString(),
                                                experience: dcm.experience,
                                                practice_location:
                                                    dcm.practice_location,
                                                fees: dcm.fees,
                                                about: dcm.about,
                                                dis_cat: dcm.dis_cat,
                                                phone: dcm.phone,
                                                working_days: dcm.working_days);
                                          },
                                        ),
                                        SizedBox(
                                          height: appSize.s18,
                                        ),

                                        Consumer<doc_cat_data>(
                                            builder: (context, cate_data, _) {
                                          category_data = cate_data.cat_items;
                                          // val=cate_data.cat_items.map((e) => ).toString();
                                          return DropdownButtonFormField(
                                              onSaved: (value) {
                                                dcm = doctor_model(
                                                    name: dcm.name,
                                                    email: dcm.email,
                                                    experience: dcm.experience,
                                                    practice_location:
                                                        dcm.practice_location,
                                                    fees: dcm.fees,
                                                    about: dcm.about,
                                                    dis_cat: value.toString(),
                                                    phone: dcm.phone,
                                                    working_days:
                                                        dcm.working_days);
                                              },
                                              decoration: InputDecoration(
                                                  prefix: Icon(
                                                    Icons.category,
                                                    color: Colors.grey,
                                                  ),
                                                  border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15))),
                                              hint: Container(
                                                margin:
                                                    EdgeInsets.only(left: 15),
                                                child: Text(
                                                  'Select Category',
                                                ),
                                              ),
                                              items: cate_data.cat_items
                                                  .map((item) {
                                                return DropdownMenuItem(
                                                    value: item.cat,
                                                    child: Container(
                                                      margin: EdgeInsets.only(
                                                          left: 15),
                                                      child: Container(
                                                        margin: EdgeInsets.only(
                                                            left: 0),
                                                        child: Text(
                                                          item.cat,
                                                          style:
                                                              getRegulerStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontsize:
                                                                      appSize
                                                                          .s14),
                                                        ),
                                                      ),
                                                    ));
                                              }).toList(),
                                              onChanged: (value) =>
                                                  setState(() {
                                                    val = value.toString();
                                                  }),
                                              validator: (value) {
                                                if (value == null) {
                                                  return 'Select Category';
                                                }
                                              });
                                        }),
                                        SizedBox(
                                          height: appSize.s18,
                                        ),
                                        Container(
                                          padding: EdgeInsets.only(
                                              left: appSize.s12),
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child: Row(
                                            // crossAxisAlignment: CrossAxisAlignment.end,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                // width: MediaQuery.of(context).size.width,
                                                child: Row(
                                                  children: [
                                                    Icon(
                                                      Icons.work_history,
                                                      color: Colors.grey[500],
                                                    ),
                                                    SizedBox(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.02,
                                                    ),
                                                    Text(
                                                      'Experience',
                                                      style: getRegulerStyle(
                                                          color: Colors.black54,
                                                          fontsize: 18),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              // SizedBox(
                                              //   width: MediaQuery.of(context).size.width * 0.,
                                              // ),
                                              Expanded(
                                                child: Container(
                                                  // width: MediaQuery.of(context).size.width * 0.55,
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    children: [
                                                      Container(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.25,
                                                        child: TextFormField(
                                                            initialValue: '',
                                                            keyboardType:
                                                                TextInputType
                                                                    .number,
                                                            decoration: InputDecoration(
                                                                border: OutlineInputBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(appSize
                                                                            .s16)),
                                                                labelText:
                                                                    'years'),
                                                            validator: (value) {
                                                              year = double.parse(
                                                                  (value!) == ''
                                                                      ? '0'
                                                                      : value);
                                                              if (year == 0.0 &&
                                                                  months ==
                                                                      0.0) {
                                                                return 'Experience*';
                                                              }
                                                            }),
                                                      ),
                                                      SizedBox(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.02,
                                                      ),
                                                      Container(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.25,
                                                        child: TextFormField(
                                                            initialValue: '',
                                                            keyboardType:
                                                                TextInputType
                                                                    .number,
                                                            decoration: InputDecoration(
                                                                border: OutlineInputBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(appSize
                                                                            .s16)),
                                                                labelText:
                                                                    'Months'),
                                                            validator: (value) {
                                                              months = double.parse(
                                                                  (value!) == ''
                                                                      ? '0'
                                                                      : value);

                                                              if (year == 0.0 &&
                                                                  months ==
                                                                      0.0) {
                                                                return '';
                                                              }
                                                            }),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(height: appSize.s18),

                                        TextFormField(
                                            onSaved: (value) {
                                              dcm = doctor_model(
                                                  name: dcm.name,
                                                  email: dcm.email,
                                                  experience: dcm.experience,
                                                  practice_location:
                                                      value.toString(),
                                                  fees: dcm.fees,
                                                  about: dcm.about,
                                                  dis_cat: dcm.dis_cat,
                                                  phone: dcm.phone,
                                                  working_days:
                                                      dcm.working_days);
                                            },
                                            minLines: 1,
                                            maxLines: 3,
                                            decoration: InputDecoration(
                                                prefixIcon:
                                                    Icon(Icons.location_city),
                                                border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            appSize.s16)),
                                                labelText: 'Practice location'),
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return 'Enter Practice location';
                                              }
                                            }),
                                        SizedBox(height: appSize.s16),
                                        TextFormField(
                                            initialValue: '',
                                            onSaved: (value) {
                                              dcm = doctor_model(
                                                  name: dcm.name,
                                                  email: dcm.email,
                                                  experience: dcm.experience,
                                                  practice_location:
                                                      dcm.practice_location,
                                                  fees: int.parse(value! == ''
                                                      ? '0'
                                                      : value),
                                                  about: dcm.about,
                                                  dis_cat: dcm.dis_cat,
                                                  phone: dcm.phone,
                                                  working_days:
                                                      dcm.working_days);
                                            },
                                            inputFormatters: [
                                              FilteringTextInputFormatter
                                                  .digitsOnly
                                            ],
                                            decoration: InputDecoration(
                                                prefixIcon: Icon(Icons.money),
                                                hintText: 'Fees (digits only)',
                                                border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            appSize.s16))),
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return "Enter doctor's fees";
                                              }
                                            }),
                                        SizedBox(height: appSize.s18),
                                        TextFormField(
                                            onSaved: (value) {
                                              dcm = doctor_model(
                                                  name: dcm.name,
                                                  email: dcm.email,
                                                  experience: dcm.experience,
                                                  practice_location:
                                                      dcm.practice_location,
                                                  fees: dcm.fees,
                                                  about: dcm.about,
                                                  dis_cat: dcm.dis_cat,
                                                  phone: value.toString(),
                                                  working_days:
                                                      dcm.working_days);
                                            },
                                            maxLength: 11,
                                            decoration: InputDecoration(
                                                prefixIcon: Icon(Icons.phone),
                                                hintText: 'Phone no',
                                                border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            appSize.s16))),
                                            validator: (value) {
                                              if (value!.length != 11) {
                                                return 'Enter 11 digits';
                                              } else if (value.isEmpty) {
                                                return 'Enter phone no';
                                              }
                                            }),
                                        SizedBox(height: appSize.s18),
                                        TextFormField(
                                            onSaved: (value) {
                                              dcm = doctor_model(
                                                  name: dcm.name,
                                                  email: dcm.email,
                                                  experience: dcm.experience,
                                                  practice_location:
                                                      dcm.practice_location,
                                                  fees: dcm.fees,
                                                  about: value.toString(),
                                                  dis_cat: dcm.dis_cat,
                                                  phone: dcm.phone,
                                                  working_days:
                                                      dcm.working_days);
                                            },
                                            minLines: 1,
                                            maxLines: 3,
                                            decoration: InputDecoration(
                                                prefixIcon:
                                                    Icon(Icons.description),
                                                hintText: 'About',
                                                border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            appSize.s16))),
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return "Enter about the doctor";
                                              }
                                            }),
                                        // DropdownButtonFormField(items: ['nose','head'].map<DropdownMenuItem>((String val) => DropdownMenuItem(
                                        //   value: val,
                                        //   child: Text(val))).toList(),onChanged: ,)
                                        SizedBox(height: appSize.s18),
                                        Container(
                                          padding: EdgeInsets.only(left: 12),
                                          alignment: Alignment.topLeft,
                                          child: Row(
                                            children: [
                                              Icon(Icons.schedule),
                                              SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.03,
                                              ),
                                              Text(
                                                'Doctor timings :',
                                                style: getMediumStyle(
                                                    color: Colors.black,
                                                    fontsize: appSize.s20),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: appSize.s18,
                                        ),
                                        Column(
                                          children: [
                                            timing('Monday'),
                                            timing('Tuesday'),
                                            timing('Wednesday'),
                                            timing('Thursday'),
                                            timing('Friday'),
                                            timing('Saturday'),
                                            timing('Sunday'),
                                          ],
                                        ),
                                        SizedBox(
                                          height: appSize.s18,
                                        ),

                                        SizedBox(
                                          height: 50,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.6,
                                          child: isSaving
                                              ? Center(
                                                  child:
                                                      CircularProgressIndicator(),
                                                )
                                              : ElevatedButton.icon(
                                                  style: getApplicationTheme()
                                                      .elevatedButtonTheme
                                                      .style,
                                                  onPressed: () async {
                                                    if (!_formKey.currentState!
                                                        .validate()) {
                                                      // Invalid!
                                                      return;
                                                    }
                                                    setState(() {
                                                      isSaving = true;
                                                    });
                                                    if (year == 0) {
                                                      if (months == 1) {
                                                        exp =
                                                            '${months.toInt()} month';
                                                      } else {
                                                        exp =
                                                            '${months.toInt()} months';
                                                      }
                                                    } else if (months == 0) {
                                                      if (year == 1) {
                                                        exp =
                                                            '${year.toInt()} year';
                                                      } else {
                                                        exp =
                                                            '${year.toInt()} years';
                                                      }
                                                    } else {
                                                      if (year == 1 &&
                                                          months == 1) {
                                                        exp =
                                                            '${year.toInt()} year and ${months.toInt()} month';
                                                      } else if (year == 1 &&
                                                          months != 1) {
                                                        exp =
                                                            '${year.toInt()} year and ${months.toInt()} months';
                                                      } else if (year != 1 &&
                                                          months == 1) {
                                                        exp =
                                                            '${year.toInt()} years and ${months.toInt()} month';
                                                      } else {
                                                        exp =
                                                            '${year.toInt()} years and ${months.toInt()} months';
                                                      }
                                                    }

                                                    dcm = doctor_model(
                                                        name: dcm.name,
                                                        email: dcm.email,
                                                        experience: exp,
                                                        practice_location: dcm
                                                            .practice_location,
                                                        fees: dcm.fees,
                                                        about: dcm.about,
                                                        dis_cat: dcm.dis_cat,
                                                        phone: dcm.phone,
                                                        working_days:
                                                            dcm.working_days);

                                                    _formKey.currentState!
                                                        .save();
                                                    await Provider.of<doctor>(
                                                            context,
                                                            listen: false)
                                                        .add_doctor(
                                                            dcm, category_data);
                                                    _formKey.currentState!
                                                        .reset();
                                                    // Focus.of(context).unfocus();
                                                    setState(() {
                                                      isSaving = false;
                                                    });

                                                    print(dcm.name);
                                                    print(dcm.dis_cat);
                                                    print(dcm.experience);
                                                    print(
                                                        dcm.practice_location);
                                                    print(dcm.fees);
                                                    print(dcm.phone);
                                                    print(dcm.about);
                                                    print(dcm.working_days);
                                                  },
                                                  icon: Icon(Icons.save),
                                                  label: Text('Add Doctor',
                                                      style: getBoldStyle(
                                                          color: Colors.white,
                                                          fontsize:
                                                              appSize.s18))),
                                        ),
                                        SizedBox(
                                          height: 15,
                                        )
                                      ],
                                    ),
                                  ))
                            ],
                          ),
                        ),
                      );
                    }))
          ],
        ));
  }

  Widget timing(text) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
              width: MediaQuery.of(context).size.width * 0.3,
              padding: EdgeInsets.only(left: appSize.s12),
              child: Text(
                '${text}',
                style: getRegulerStyle(
                    color: ColorManager.darkGrey, fontsize: appSize.s16),
              )),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.05,
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.only(right: appSize.s12),
              child: TextFormField(
                  onSaved: (value) {
                    dcm = doctor_model(
                        name: dcm.name,
                        email: dcm.email,
                        experience: dcm.experience,
                        practice_location: dcm.practice_location,
                        fees: dcm.fees,
                        about: dcm.about,
                        dis_cat: dcm.dis_cat,
                        phone: dcm.phone,
                        working_days: {
                          'monday': text.toLowerCase() == 'monday'
                              ? value
                              : dcm.working_days['monday'],
                          'tuesday': text.toLowerCase() == 'tuesday'
                              ? value
                              : dcm.working_days['tuesday'],
                          'wednesday': text.toLowerCase() == 'wednesday'
                              ? value
                              : dcm.working_days['wednesday'],
                          'thursday': text.toLowerCase() == 'thursday'
                              ? value
                              : dcm.working_days['thursday'],
                          'friday': text.toLowerCase() == 'friday'
                              ? value
                              : dcm.working_days['friday'],
                          'saturday': text.toLowerCase() == 'saturday'
                              ? value
                              : dcm.working_days['saturday'],
                          'sunday': text.toLowerCase() == 'sunday'
                              ? value
                              : dcm.working_days['sunday'],
                        });
                  },
                  decoration: InputDecoration(
                      hintText: 'Enter ${text.toLowerCase()} timing here'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Enter ${text} timing";
                    }
                  }),
            ),
          )
        ],
      ),
    );
  }
}
