import 'package:chill/bloc/signup/bloc.dart';
import 'package:chill/repositories/userRepository.dart';
import 'package:chill/ui/widgets/loginForm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/authentication/authentication_bloc.dart';
import '../../bloc/authentication/authentication_event.dart';
import '../constants.dart';

class SignUpForm extends StatefulWidget {
  final UserRepository _userRepository;

  SignUpForm({required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository;

  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  late SignUpBloc _signUpBloc;

  bool get isPopulated =>
      _emailController.text.isNotEmpty && _passwordController.text.isNotEmpty;

  bool isSignUpButtonEnabled(SignUpState state) {
    return isPopulated && !state.isSubmitting;
  }

  @override
  void initState() {
    _signUpBloc = SignUpBloc(
      userRepository: widget._userRepository,
    );

    _emailController.addListener(_onEmailChanged);
    _passwordController.addListener(_onPasswordChanged);

    super.initState();
  }

  void _onFormSubmitted() {
    _signUpBloc.add(
      SignUpWithCredentialsPressed(
        email: _emailController.text,
        password: _passwordController.text,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Your UI code here (no changes needed)

    return BlocListener<SignUpBloc, SignUpState>(listener: (BuildContext context, SignUpState state) {  },
      // Your BlocListener code here (no changes needed)
    );
  }

  void _onEmailChanged() {
    _signUpBloc.add(
      SignUpEmailChanged(email: _emailController.text) as SignUpEvent,
    );
  }

  void _onPasswordChanged() {
    _signUpBloc.add(
      SignUpPasswordChanged(password: _passwordController.text) as SignUpEvent,
    );
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _emailController.dispose();

    super.dispose();
  }
}

class SignUpEmailChanged {
  final String email;

  SignUpEmailChanged({required this.email});
}

class SignUpPasswordChanged {
  final String password;

  SignUpPasswordChanged({required this.password});
}
