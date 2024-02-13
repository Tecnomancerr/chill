import 'package:chill/bloc/authentication/authentication_bloc.dart';
import 'package:chill/repositories/userRepository.dart';
import 'package:chill/ui/pages/home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/authentication/authentication_event.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform,);

  final UserRepository _userRepository = UserRepository();

  runApp(BlocProvider(
    create: (context) => AuthenticationBloc(userRepository: _userRepository),
    child: Home(userRepository: _userRepository),
  ));
}
