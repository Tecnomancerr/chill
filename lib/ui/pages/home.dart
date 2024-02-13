import 'package:chill/bloc/authentication/authentication_bloc.dart';
import 'package:chill/bloc/authentication/authentication_event.dart';
import 'package:chill/bloc/authentication/authentication_state.dart';
import 'package:chill/repositories/userRepository.dart';
import 'package:chill/ui/pages/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chill/ui/pages/splash.dart';
import '../widgets/tabs.dart';
import 'login.dart';

class Home extends StatelessWidget {
  final UserRepository userRepository;

  Home({required this.userRepository});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          if (state is Uninitialized) {
            return Splash();
          } else if (state is Authenticated) {
            return Tabs();
          } else if (state is AuthenticatedButNotSet) {
            return Profile(
              userRepository: userRepository,
              userId: state.userId,
            );
          } else if (state is Unauthenticated) {
            return Login(
              userRepository: userRepository,
            );
          } else {
            return Container(
              child: Text("Fucked"),
            );
          }
        },
      ),
    );
  }
}
