import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:chill/repositories/userRepository.dart';
import 'package:chill/ui/validators.dart';
import 'package:meta/meta.dart';
import './bloc.dart';
import 'package:rxdart/rxdart.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  final UserRepository _userRepository;

  SignUpBloc({required UserRepository userRepository})
      : _userRepository = userRepository,
        super(SignUpState.empty());

  @override
  Stream<SignUpState> mapEventToState(SignUpEvent event) async* {
    if (event is EmailChanged) {
      yield* _mapEmailChangedToState(event.email);
    } else if (event is PasswordChanged) {
      yield* _mapPasswordChangedToState(event.password);
    } else if (event is SignUpWithCredentialsPressed) {
      yield* _mapSignUpWithCredentialsPressedToState(
          email: event.email, password: event.password);
    }
  }

  Stream<SignUpState> _mapEmailChangedToState(String email) async* {
    yield state.update(
      isEmailValid: Validators.isValidEmail(email),
      isPasswordValid: state.isPasswordValid,
    );
  }

  Stream<SignUpState> _mapPasswordChangedToState(String password) async* {
    yield state.update(
      isEmailValid: state.isEmailValid,
      isPasswordValid: Validators.isValidPassword(password),
    );
  }

  Stream<SignUpState> _mapSignUpWithCredentialsPressedToState({
    required String email,
    required String password,
  }) async* {
    yield SignUpState.loading();

    try {
      await _userRepository.signUpWithEmail(email, password);

      yield SignUpState.success();
    } catch (_) {
      yield SignUpState.failure();
    }
  }
}
