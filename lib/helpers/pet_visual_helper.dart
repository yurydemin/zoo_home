import 'package:flutter/material.dart';
import 'package:zoo_home/models/ModelProvider.dart';

class PetVisualHelper {
  static Color petStatusToColor(PetStatus status) {
    if (status == PetStatus.OPENED) {
      return Colors.green;
    } else if (status == PetStatus.RESERVED) {
      return Colors.yellow;
    } else {
      return Colors.red;
    }
  }

  static String petStatusToString(PetStatus status) {
    if (status == PetStatus.OPENED) {
      return 'Opened';
    } else if (status == PetStatus.RESERVED) {
      return 'Reserved';
    } else {
      return 'Closed';
    }
  }

  static String petKindToString(PetKind kind) {
    if (kind == PetKind.CAT) {
      return 'Cat';
    } else if (kind == PetKind.DOG) {
      return 'Dog';
    } else {
      return 'Other';
    }
  }
}
