import 'package:chill/bloc/authentication/authentication_bloc.dart';
import 'package:chill/bloc/authentication/authentication_event.dart';
import 'package:chill/repositories/userRepository.dart';
import 'package:chill/ui/constants.dart';
import 'package:chill/ui/pages/signUp.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Define custom states for your LoginBloc
abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {}

class LoginFailure extends LoginState {
  final String error;

  LoginFailure({required this.error});
}

// Define custom events for your LoginBloc
abstract class LoginEvent {}

class EmailChanged extends LoginEvent {
  final String email;

  EmailChanged({required this.email});
}

class PasswordChanged extends LoginEvent {
  final String password;

  PasswordChanged({required this.password});
}

class LoginWithCredentialsPressed extends LoginEvent {
  final String email;
  final String password;

  LoginWithCredentialsPressed({
    required this.email,
    required this.password,
  });
}

// Define the LoginBloc
class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final UserRepository userRepository;

  LoginBloc({required this.userRepository}) : super(LoginInitial());

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is EmailChanged || event is PasswordChanged) {
      yield LoginInitial();
    } else if (event is LoginWithCredentialsPressed) {
      yield LoginLoading();

      try {
        // Perform the login logic here, e.g., call an API to validate credentials
        // If login is successful:
        // final user = await userRepository.login(event.email, event.password);
        // yield LoginSuccess(user: user);

        // For now, simulate a successful login
        await Future.delayed(Duration(seconds: 2));
        yield LoginSuccess();
      } catch (error) {
        yield LoginFailure(error: "Login failed. Please try again.");
      }
    }
  }
}

class LoginForm extends StatefulWidget {
  final UserRepository userRepository;

  LoginForm({required this.userRepository});

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  late LoginBloc _loginBloc;

  UserRepository get _userRepository => widget.userRepository;

  @override
  void initState() {
    super.initState();
    _loginBloc = LoginBloc(userRepository: _userRepository);
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _emailController.dispose();
    _loginBloc.close();

    super.dispose();
  }

  void _onFormSubmitted() {
    _loginBloc.add(
      LoginWithCredentialsPressed(
        email: _emailController.text,
        password: _passwordController.text,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state is LoginFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text("Login Failed: ${state.error}"),
                    Icon(Icons.error),
                  ],
                ),
              ),
            );
        }

        if (state is LoginLoading) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text("Logging In..."),
                    CircularProgressIndicator(),
                  ],
                ),
              ),
            );
        }

        if (state is LoginSuccess) {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          BlocProvider.of<AuthenticationBloc>(context).add(LoggedIn());
        }
      },
      child: SingleChildScrollView(
        child: Container(
          color: backgroundColor,
          width: size.width,
          height: size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Center(
                child: Text(
                  "Chill",
                  style: TextStyle(
                    fontSize: size.width * 0.2,
                    color: Colors.white,
                  ),
                ),
              ),
              Container(
                width: size.width * 0.8,
                child: Divider(
                  height: size.height * 0.05,
                  color: Colors.white,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(size.height * 0.02),
                child: TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: "Email",
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
              ),
              Padding(
                padding: EdgeInsets.all(size.height * 0.02),
                child: TextFormField(
                  controller: _passwordController,
                  autocorrect: false,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "Password",
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
              ),
              Padding(
                padding: EdgeInsets.all(size.height * 0.02),
                child: Column(
                  children: <Widget>[
                    GestureDetector(
                      onTap: _onFormSubmitted,
                      child: Container(
                        width: size.width * 0.8,
                        height: size.height * 0.06,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(
                            size.height * 0.05,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            "Login",
                            style: TextStyle(
                              fontSize: size.height * 0.025,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: size.height * 0.02,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) {
                              return SignUp(
                                userRepository: _userRepository,
                              );
                            },
                          ),
                        );
                      },
                      child: Text(
                        "Are you new? Get an Account",
                        style: TextStyle(
                          fontSize: size.height * 0.025,
                          color: Colors.white,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
