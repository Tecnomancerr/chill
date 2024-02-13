import 'package:flutter/material.dart';

import '../constants.dart';

class Splash extends StatelessWidget {
  const Splash({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;


    return Scaffold(
      backgroundColor: backgroundColor,
      body: Container(
        width: size.width,
        child: Center(
          child: Text(
            "TRIP",
            style: TextStyle(
              color: Colors.white,
              fontSize: size.width*0.2,
            ),
          ),
        ),
      ),
    );
  }
}
