import 'package:doctors_app/data/auth_data.dart';
import 'package:doctors_app/widgets/form.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class authentication extends StatefulWidget {
  @override
  State<authentication> createState() => _authenticationState();
}

class _authenticationState extends State<authentication> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  Image.asset(
                    "assets/images/login3.jpg",
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    fit: BoxFit.cover,
                  ),
                  form()
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
