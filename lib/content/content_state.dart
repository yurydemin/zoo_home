import 'package:flutter/widgets.dart';
import 'package:zoo_home/models/ModelProvider.dart';

class ContentState {
  final Shelter currentShelter;
  final Pet currentPet;

  ContentState({@required this.currentShelter, @required this.currentPet});
}
