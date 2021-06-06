import 'package:flutter/widgets.dart';
import 'package:zoo_home/models/ModelProvider.dart';

class ContentState {
  final Shelter selectedShelter;
  final int selectedPetIndex;

  ContentState(
      {@required this.selectedShelter, @required this.selectedPetIndex});
}
