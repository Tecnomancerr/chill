import 'dart:async';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:chill/repositories/userRepository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import './bloc.dart';

class UserProfileState {
  final bool isNameEmpty;
  final bool isPhotoEmpty;
  final bool isAgeEmpty;
  final bool isGenderEmpty;
  final bool isInterestedInEmpty;
  final bool isLocationEmpty;
  final bool isLoading;
  final bool isSuccess;
  final bool isFailure;

  UserProfileState({
    required this.isNameEmpty,
    required this.isPhotoEmpty,
    required this.isAgeEmpty,
    required this.isGenderEmpty,
    required this.isInterestedInEmpty,
    required this.isLocationEmpty,
    required this.isLoading,
    required this.isSuccess,
    required this.isFailure,
  });

  factory UserProfileState.initial() {
    return UserProfileState(
      isNameEmpty: false,
      isPhotoEmpty: false,
      isAgeEmpty: false,
      isGenderEmpty: false,
      isInterestedInEmpty: false,
      isLocationEmpty: false,
      isLoading: false,
      isSuccess: false,
      isFailure: false,
    );
  }

  factory UserProfileState.loading() {
    return UserProfileState(
      isNameEmpty: false,
      isPhotoEmpty: false,
      isAgeEmpty: false,
      isGenderEmpty: false,
      isInterestedInEmpty: false,
      isLocationEmpty: false,
      isLoading: true,
      isSuccess: false,
      isFailure: false,
    );
  }

  factory UserProfileState.success() {
    return UserProfileState(
      isNameEmpty: false,
      isPhotoEmpty: false,
      isAgeEmpty: false,
      isGenderEmpty: false,
      isInterestedInEmpty: false,
      isLocationEmpty: false,
      isLoading: false,
      isSuccess: true,
      isFailure: false,
    );
  }

  factory UserProfileState.failure() {
    return UserProfileState(
      isNameEmpty: false,
      isPhotoEmpty: false,
      isAgeEmpty: false,
      isGenderEmpty: false,
      isInterestedInEmpty: false,
      isLocationEmpty: false,
      isLoading: false,
      isSuccess: false,
      isFailure: true,
    );
  }
}

class ProfileBloc extends Bloc<ProfileEvent, UserProfileState> {
  UserRepository _userRepository;

  ProfileBloc({required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(UserProfileState.initial());

  @override
  Stream<UserProfileState> mapEventToState(ProfileEvent event) async* {
    if (event is NameChanged) {
      yield* _mapNameChangedToState(event.name);
    } else if (event is AgeChanged) {
      yield* _mapAgeChangedToState(event.age);
    } else if (event is GenderChanged) {
      yield* _mapGenderChangedToState(event.gender);
    } else if (event is InterestedInChanged) {
      yield* _mapInterestedInChangedToState(event.interestedIn);
    } else if (event is LocationChanged) {
      yield* _mapLocationChangedToState(event.location);
    } else if (event is PhotoChanged) {
      yield* _mapPhotoChangedToState(event.photo);
    } else if (event is Submitted) {
      final uid = await _userRepository.getUserId();
      yield* _mapSubmittedToState(
        photo: event.photo,
        name: event.name,
        gender: event.gender,
        userId: uid,
        age: event.age,
        location: event.location,
        interestedIn: event.interestedIn,
      );
    }
  }

  Stream<UserProfileState> _mapNameChangedToState(String name) async* {
    // Implement logic to handle name change and update state
  }

  Stream<UserProfileState> _mapPhotoChangedToState(File? photo) async* {
    // Implement logic to handle photo change and update state
  }

  Stream<UserProfileState> _mapAgeChangedToState(DateTime age) async* {
    // Implement logic to handle age change and update state
  }

  Stream<UserProfileState> _mapGenderChangedToState(String gender) async* {
    // Implement logic to handle gender change and update state
  }

  Stream<UserProfileState> _mapInterestedInChangedToState(
      String interestedIn) async* {
    // Implement logic to handle interestedIn change and update state
  }

  Stream<UserProfileState> _mapLocationChangedToState(GeoPoint location) async* {
    // Implement logic to handle location change and update state
  }

  Stream<UserProfileState> _mapSubmittedToState({
    File? photo,
    String? gender,
    String? name,
    String? userId,
    DateTime? age,
    GeoPoint? location,
    String? interestedIn,
  }) async* {
    yield UserProfileState.loading();
    try {
      // Implement logic to submit the profile data
      // You may call _userRepository.profileSetup here

      // After successfully submitting, yield success state
      yield UserProfileState.success();
    } catch (_) {
      // Handle the error case
      yield UserProfileState.failure();
    }
  }
}
