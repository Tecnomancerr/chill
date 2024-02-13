import 'dart:io';

import 'package:chill/bloc/authentication/authentication_bloc.dart';
import 'package:chill/bloc/authentication/authentication_event.dart';
import 'package:chill/bloc/profile/bloc.dart'; // Import your ProfileBloc correctly.
import 'package:chill/repositories/userRepository.dart';
import 'package:chill/ui/constants.dart';
import 'package:chill/ui/widgets/gender.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';

class ProfileForm extends StatefulWidget {
  final UserRepository _userRepository;

  ProfileForm({required UserRepository userRepository})
      : _userRepository = userRepository;

  @override
  _ProfileFormState createState() => _ProfileFormState();
}

class _ProfileFormState extends State<ProfileForm> {
  final TextEditingController _nameController = TextEditingController();

  String? gender, interestedIn;
  DateTime? age;
  File? photo;
  GeoPoint? location;
  late ProfileBloc _profileBloc;

  bool get isFilled =>
      _nameController.text.isNotEmpty &&
          gender != null &&
          interestedIn != null &&
          photo != null &&
          age != null;

  bool isButtonEnabled(ProfileState state) {
    return isFilled && !state.isSubmitting;
  }

  Future<void> _getLocation() async {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    location = GeoPoint(position.latitude, position.longitude);
  }

  void _onSubmitted() async {
    await _getLocation();
    _profileBloc.add(
      Submitted(
        name: _nameController.text,
        age: age!,
        location: location!,
        gender: gender!,
        interestedIn: interestedIn!,
        photo: photo!,
      ),
    );
  }

  @override
  void initState() {
    _getLocation();
    _profileBloc = BlocProvider.of<ProfileBloc>(context);
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return BlocListener<ProfileBloc, UserProfileState>(
      listener: (context, state) {
        if (state is ProfileFailure) { // Corrected state type check.
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('Profile Creation Unsuccessful'),
                    Icon(Icons.error)
                  ],
                ),
              ),
            );
        }
        if (state is ProfileSubmitting) { // Corrected state type check.
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('Submitting'),
                    CircularProgressIndicator()
                  ],
                ),
              ),
            );
        }
        if (state is ProfileSuccess) { // Corrected state type check.
          BlocProvider.of<AuthenticationBloc>(context).add(LoggedIn());
        }
      },
      child: BlocBuilder<ProfileBloc, UserProfileState>(
        builder: (context, state) {
          return SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Container(
              color: backgroundColor,
              width: size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: size.width,
                    child: CircleAvatar(
                      radius: size.width * 0.3,
                      backgroundColor: Colors.transparent,
                      child: photo == null
                          ? GestureDetector(
                        onTap: () async {
                          FilePickerResult? result =
                          await FilePicker.platform.pickFiles(
                            type: FileType.image,
                          );
                          if (result != null) {
                            setState(() {
                              photo = File(result.files.single.path!);
                            });
                          }
                        },
                        child: Image.asset('assets/profilephoto.png'),
                      )
                          : GestureDetector(
                        onTap: () async {
                          FilePickerResult? result =
                          await FilePicker.platform.pickFiles(
                            type: FileType.image,
                          );
                          if (result != null) {
                            setState(() {
                              photo = File(result.files.single.path!);
                            });
                          }
                        },
                        child: CircleAvatar(
                          radius: size.width * 0.3,
                          backgroundImage: FileImage(photo!),
                        ),
                      ),
                    ),
                  ),
                  textFieldWidget(_nameController, "Name", size),
                  GestureDetector(
                    onTap: () {
                      DatePicker.showDatePicker(
                        context,
                        showTitleActions: true,
                        minTime: DateTime(1900, 1, 1),
                        maxTime: DateTime(DateTime.now().year - 19, 1, 1),
                        onConfirm: (date) {
                          setState(() {
                            age = date;
                          });
                          print(age);
                        },
                      );
                    },
                    child: Text(
                      "Enter Birthday",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: size.width * 0.09,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: size.height * 0.02),
                        child: Text(
                          "You Are",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: size.width * 0.09,
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          genderWidget(
                            FontAwesomeIcons.venus,
                            "Female",
                            size,
                            gender,
                                () {
                              setState(() {
                                gender = "Female";
                              });
                            },
                          ),
                          genderWidget(
                            FontAwesomeIcons.mars,
                            "Male",
                            size,
                            gender,
                                () {
                              setState(() {
                                gender = "Male";
                              });
                            },
                          ),
                          genderWidget(
                            FontAwesomeIcons.transgender,
                            "Transgender",
                            size,
                            gender,
                                () {
                              setState(() {
                                gender = "Transgender";
                              });
                            },
                          ),
                        ],
                      ),
                      SizedBox(
                        height: size.height * 0.02,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: size.height * 0.02),
                        child: Text(
                          "Looking For",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: size.width * 0.09,
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          genderWidget(
                            FontAwesomeIcons.venus,
                            "Female",
                            size,
                            interestedIn,
                                () {
                              setState(() {
                                interestedIn = "Female";
                              });
                            },
                          ),
                          genderWidget(
                            FontAwesomeIcons.mars,
                            "Male",
                            size,
                            interestedIn,
                                () {
                              setState(() {
                                interestedIn = "Male";
                              });
                            },
                          ),
                          genderWidget(
                            FontAwesomeIcons.transgender,
                            "Transgender",
                            size,
                            interestedIn,
                                () {
                              setState(() {
                                interestedIn = "Transgender";
                              });
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: size.height * 0.02),
                    child: GestureDetector(
                      onTap: () {
                        if (isButtonEnabled(state as ProfileState)) {
                          _onSubmitted();
                        } else {}
                      },
                      child: Container(
                        width: size.width * 0.8,
                        height: size.height * 0.06,
                        decoration: BoxDecoration(
                          color: isButtonEnabled(state as ProfileState)
                              ? Colors.white
                              : Colors.grey,
                          borderRadius:
                          BorderRadius.circular(size.height * 0.05),
                        ),
                        child: Center(
                          child: Text(
                            "Save",
                            style: TextStyle(
                              fontSize: size.height * 0.025,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class ProfileSuccess extends ProfileState {
  ProfileSuccess({required super.isPhotoEmpty,
    required super.isNameEmpty
    , required super.isAgeEmpty,
    required super.isGenderEmpty,
    required super.isInterestedInEmpty,
    required super.isLocationEmpty,
    required super.isFailure,
    required super.isSubmitting,
    required super.isSuccess});
}


class ProfileSubmitting extends ProfileState {
  final bool isPhotoEmpty,
      isNameEmpty,
      isAgeEmpty,
      isGenderEmpty,
      isInterestedInEmpty,
      isLocationEmpty,
      isFailure,
      isSubmitting,
      isSuccess;

  ProfileSubmitting({
    required this.isPhotoEmpty,
    required this.isNameEmpty,
    required this.isAgeEmpty,
    required this.isGenderEmpty,
    required this.isInterestedInEmpty,
    required this.isLocationEmpty,
    required this.isFailure,
    required this.isSubmitting,
    required this.isSuccess})

      : super(isPhotoEmpty: false,
      isNameEmpty: false,
      isAgeEmpty: false,
      isGenderEmpty: false,
      isInterestedInEmpty: false,
      isLocationEmpty: false,
      isFailure: false,
      isSubmitting: false,
      isSuccess: false);

  @override
  List<Object?> get props => [
    isPhotoEmpty,
    isNameEmpty,
    isAgeEmpty,
    isGenderEmpty,
    isInterestedInEmpty,
    isLocationEmpty,
    isFailure,
    isSubmitting,
    isSuccess];
}


class ProfileFailure extends ProfileState {
  final String error;

  ProfileFailure( this.error, {required super.isPhotoEmpty,
  required super.isNameEmpty,
  required super.isAgeEmpty,
  required super.isGenderEmpty,
  required super.isInterestedInEmpty,
  required super.isLocationEmpty,
  required super.isFailure,
  required super.isSubmitting,
  required super.isSuccess}
  );

  @override
  List<Object?> get props => [error];
}
Widget textFieldWidget(controller, text, size) {
  return Padding(
    padding: EdgeInsets.all(size.height * 0.02),
    child: TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: text,
        labelStyle: TextStyle(
          color: Colors.white,
          fontSize: size.height * 0.03,
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.white,
            width: 1.0,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.white,
            width: 1.0,
          ),
        ),
      ),
    ),
  );
}
