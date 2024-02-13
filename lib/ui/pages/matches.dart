import 'package:chill/bloc/matches/bloc.dart';
import 'package:chill/models/user.dart';
import 'package:chill/repositories/matchesRepository.dart';
import 'package:chill/ui/widgets/iconWidget.dart';
import 'package:chill/ui/widgets/pageTurn.dart';
import 'package:chill/ui/widgets/profile.dart';
import 'package:chill/ui/widgets/userGender.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';

import 'messaging.dart';

class Matches extends StatefulWidget {
  final String userId;

  const Matches({required this.userId}); // Add 'required' for userId

  @override
  _MatchesState createState() => _MatchesState();
}

class _MatchesState extends State<Matches> {
  MatchesRepository matchesRepository = MatchesRepository();
  late MatchesBloc _matchesBloc; // Initialize _matchesBloc

  int? difference; // Make difference nullable

  // Add 'async' to getDifference method
  Future<void> getDifference(GeoPoint userLocation) async {
    Position position = await Geolocator.getCurrentPosition();

    double location = await Geolocator.distanceBetween(
      userLocation.latitude,
      userLocation.longitude,
      position.latitude,
      position.longitude,
    );

    setState(() {
      difference = location.toInt();
    });
  }

  @override
  void initState() {
    super.initState();
    _matchesBloc = MatchesBloc(matchesRepository: matchesRepository); // Initialize _matchesBloc here
    _matchesBloc.add(LoadListsEvent(userId: widget.userId)); // Move the event here
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Title'),
      ),
     // body: YourWidgetTree(), // Your actual widget tree goes here
    );
    // Rest of your code remains the same
  }
}
