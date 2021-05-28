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
      return 'Открыто';
    } else if (status == PetStatus.RESERVED) {
      return 'Зарезервировано';
    } else {
      return 'Закрыто';
    }
  }

  static String petKindToString(PetKind kind) {
    if (kind == PetKind.CAT) {
      return 'Кошка';
    } else if (kind == PetKind.DOG) {
      return 'Собака';
    } else {
      return 'Другое';
    }
  }
}
