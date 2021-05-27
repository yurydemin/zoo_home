import 'package:flutter/widgets.dart';
import 'package:zoo_home/models/ModelProvider.dart';
import 'package:zoo_home/models/UserShelter.dart';

class ContentState {
  final UserShelter currentUserShelter;
  final Pet currentPet;

  ContentState({@required this.currentUserShelter, @required this.currentPet});
}
