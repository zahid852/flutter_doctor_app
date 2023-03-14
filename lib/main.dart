import 'dart:math';

import 'package:doctors_app/application/app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //step4 init the firebase
  await Firebase.initializeApp();
  runApp(myApp());
}
