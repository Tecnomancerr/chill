import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

Widget userGender(gender) {
  switch (gender) {
    case 'Male':
      return Icon(
        FontAwesomeIcons.mars,
        color: Colors.white,
      );
    case 'Female':
      return Icon(
        FontAwesomeIcons.venus,
        color: Colors.white,
      );
    case 'Transgender':
      return Icon(
        FontAwesomeIcons.transgender,
        color: Colors.white,
      );
    default:
      return Icon(
        FontAwesomeIcons.question,
        color: Colors.white,
      ); // Return a default icon or widget
  }
}
