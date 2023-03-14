// ignore_for_file: deprecated_member_use

import 'dart:io';

import 'package:doctors_app/data/auth_data.dart';
import 'package:doctors_app/data/exception.dart';
import 'package:doctors_app/presentation/presentations.dart';
import 'package:doctors_app/widgets/pickers/userImagePicker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class form extends StatefulWidget {
  @override
  State<form> createState() => _formState();
}

class _formState extends State<form> {
  bool isLoading = false;
  File? UserPickedImage;
  void _pickedImage(File image) {
    UserPickedImage = image;
  }

  List<String> items = ['User', 'Doctor', 'Admin'];
  void _showErrorDialog(String errorMessage) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: SizedBox(
              height: MediaQuery.of(context).size.height * 0.2,
              width: MediaQuery.of(context).size.width * 0.5,
              child: Container(child: Lottie.asset("assets/json/error.json")),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Error occured!',
                  style:
                      getBoldStyle(color: ColorManager.primery, fontsize: 18),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.01,
                ),
                Text(
                  errorMessage,
                  style: getRegulerStyle(color: Colors.black, fontsize: 15),
                )
              ],
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Ok'))
            ],
          );
        });
  }

  void submit() async {
    bool validate = formKey.currentState!.validate();
    if (UserPickedImage == null && isSignUp == true) {
      //   Scaffold.of(context).showSnackBar(SnackBar(
      //     content: Text(
      //       'Please pick an image',
      //     ),
      //     backgroundColor: Colors.red,
      //   ));
      return;
    }

    if (validate == false) {
      return;
    } else {
      formKey.currentState!.save();
      // formKey.currentState!.reset();
      //todo backend
      setState(() {
        isLoading = true;
      });
      try {
        if (!isSignUp) {
          Provider.of<Auth>(context, listen: false).setAlreadySigned(false);
          await Provider.of<Auth>(context, listen: false)
              .signIn(email: data['email'], password: data['password']);
        } else {
          Provider.of<Auth>(context, listen: false).setAlreadySigned(false);
          await Provider.of<Auth>(context, listen: false).signUp(
            username: data['username'],
            type: data['type'],
            email: data['email'],
            password: data['password'],
            image: UserPickedImage,
          );
        }
      } on HttpException catch (error) {
        print(' sign up error is $error');
        String errorMessage = 'Could not Authenticate. \n Try again';
        //for signUp
        if (error.toString().contains('EMAIL_EXISTS')) {
          errorMessage = 'Email Already Exists!';
        } else if (error.toString().contains('INVALID_EMAIL')) {
          errorMessage = 'Email is not correct';
        } else if (error.toString().contains('WEAK_PASSWORD')) {
          errorMessage = 'Password is Weak';
        }
        // for signIn
        else if (error.toString().contains('EMAIL_NOT_FOUND')) {
          errorMessage = 'You Don\'t have account \n SignUp Now';
        } else if (error.toString().contains('INVALID_PASSWORD')) {
          errorMessage = 'Invalid Password';
        } else if (error.toString().contains('DOCTOR')) {
          errorMessage =
              "You are not register yet as a doctor. \nContact Admin.";
        } else if (error.toString().contains('TOO_MANY_ATTEMPTS_TRY_LATER')) {
          errorMessage =
              'You have made too many attempts. \n Try again after some time';
        }
        _showErrorDialog(errorMessage);
      } catch (error) {
        print('catch error is $error');
        String errorMessage = "Something went wrong.";
        _showErrorDialog(errorMessage);
      }
      if (mounted) {
        // check whether the state object is in tree
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Map<String, String> data = {
    'username': '',
    'type': '',
    'email': "",
    'password': ''
  };

  bool isSignUp = false;
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.7),
          borderRadius: BorderRadius.circular(10)),
      margin: EdgeInsets.symmetric(horizontal: 30),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isSignUp)
                  Column(
                    children: [
                      UserImagePicker(_pickedImage),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.025,
                      ),
                      TextFormField(
                        style: getRegulerStyle(
                            color: ColorManager.white, fontsize: 16),
                        decoration: InputDecoration(
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 20, vertical: 2),
                          // hintText: "Username",
                          label: Text("Username"),
                          labelStyle: getRegulerStyle(
                              color: ColorManager.white, fontsize: 16),
                          prefixIcon: Icon(
                            Icons.person,
                            color: Colors.white,
                            size: 20,
                          ),
                          // hintStyle: getRegulerStyle(
                          //     color: ColorManager.white, fontsize: 14),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: ColorManager.white),
                              borderRadius: BorderRadius.circular(30)),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30)),
                        ),
                        validator: (username) {
                          if (username!.isEmpty) {
                            return "Invalid username";
                          }
                        },
                        onSaved: (username) {
                          data['username'] = username!;
                        },
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.025,
                      ),
                    ],
                  ),
                if (isSignUp == false)
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.025,
                  ),
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  style:
                      getRegulerStyle(color: ColorManager.white, fontsize: 16),
                  decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 2),
                      // hintText: "Email",
                      label: Text("Email"),
                      labelStyle: getRegulerStyle(
                          color: ColorManager.white, fontsize: 16),
                      prefixIcon: Icon(
                        Icons.email,
                        color: Colors.white,
                        size: 20,
                      ),
                      // hintStyle: getRegulerStyle(
                      //     color: ColorManager.white, fontsize: 14),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: ColorManager.white),
                          borderRadius: BorderRadius.circular(30)),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30))),
                  validator: (email) {
                    if (email!.isEmpty || !email.contains("@")) {
                      return "Invalid Email";
                    }
                  },
                  onSaved: (email) {
                    data['email'] = email!;
                  },
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.025,
                ),
                TextFormField(
                  style:
                      getRegulerStyle(color: ColorManager.white, fontsize: 16),
                  decoration: InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 20, vertical: 2),
                    // hintText: "Password",
                    label: Text("Password"),
                    labelStyle: getRegulerStyle(
                        color: ColorManager.white, fontsize: 16),
                    prefixIcon: Icon(
                      Icons.lock,
                      color: Colors.white,
                      size: 20,
                    ),
                    // hintStyle: getRegulerStyle(
                    //     color: ColorManager.white, fontsize: 14),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: ColorManager.white),
                        borderRadius: BorderRadius.circular(30)),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30)),
                  ),
                  validator: (password) {
                    if (password!.length < 5) {
                      return "Invalid Password";
                    }
                  },
                  onSaved: (password) {
                    data['password'] = password!;
                  },
                ),
                if (isSignUp)
                  Column(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.025,
                      ),
                      DropdownButtonFormField(
                          borderRadius: BorderRadius.circular(10),
                          iconEnabledColor: Colors.white,
                          onSaved: (value) {
                            data['type'] = value.toString();
                          },
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.fromLTRB(20, 2, 0, 2),
                            prefixIcon: Icon(
                              Icons.category,
                              color: Colors.white,
                              size: 20,
                            ),
                            label: Text("Select Category"),
                            labelStyle: getRegulerStyle(
                                color: ColorManager.white, fontsize: 16),
                            enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: ColorManager.white),
                                borderRadius: BorderRadius.circular(30)),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30)),
                          ),
                          selectedItemBuilder: (BuildContext context) {
                            //<-- SEE HERE
                            return items.map((String value) {
                              return Text(
                                data['type']!,
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 16),
                              );
                            }).toList();
                          },
                          items: items.map((item) {
                            return DropdownMenuItem(
                                value: item,
                                child: Container(
                                  margin: EdgeInsets.only(left: 0),
                                  child: Text(
                                    item,
                                    style: getRegulerStyle(
                                        color: Colors.black,
                                        fontsize: appSize.s16),
                                  ),
                                ));
                          }).toList(),
                          onChanged: (value) => setState(() {
                                data['type'] = value.toString();
                              }),
                          validator: (value) {
                            if (value == null) {
                              return 'Select Category';
                            }
                          }),
                    ],
                  ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.05,
                ),
                isLoading
                    ? Container(
                        height: 48,
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      )
                    : Container(
                        height: 48,
                        width: MediaQuery.of(context).size.width * 0.5,
                        decoration: BoxDecoration(
                            color: ColorManager.white,
                            borderRadius: BorderRadius.circular(30)),
                        child: TextButton(
                            onPressed: () {
                              submit();
                            },
                            child: Text(
                              isSignUp ? "Sign up" : "Login",
                              style: getMediumStyle(
                                  color: Colors.black, fontsize: 16),
                            )),
                      ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.012,
                ),
                TextButton(
                    onPressed: () {
                      setState(() {
                        isSignUp = !isSignUp;
                      });
                    },
                    child: Text(
                      isSignUp ? "Login Instead" : "Signup instead",
                      style: TextStyle(
                          fontSize: 17,
                          color: Colors.white,
                          fontWeight: FontWeightManager.medium,
                          decoration: TextDecoration.underline),
                    )),
              ],
            )),
      ),
    );
  }
}
