import 'package:flutter/material.dart';
import 'package:zoo_home/models/ModelProvider.dart';

class PetVisualHelper {
  static Map<PetStatus, String> _petStatusMap = {
    PetStatus.OPENED: 'Открыто',
    PetStatus.RESERVED: 'Зарезервировано',
    PetStatus.CLOSED: 'Закрыто'
  };

  static Map<PetKind, String> _petKindMap = {
    PetKind.CAT: 'Кошка',
    PetKind.DOG: 'Собака',
    PetKind.OTHER: 'Другое'
  };

  static String petStatusToString(PetStatus status) {
    return _petStatusMap.containsKey(status)
        ? _petStatusMap[status]
        : _petStatusMap[PetStatus.OPENED];
  }

  static PetStatus petStatusFromString(String petStatusString) {
    return _petStatusMap.keys.firstWhere(
        (k) => _petStatusMap[k] == petStatusString,
        orElse: () => PetStatus.OPENED);
  }

  static String petKindToString(PetKind kind) {
    return _petKindMap.containsKey(kind)
        ? _petKindMap[kind]
        : _petKindMap[PetKind.OTHER];
  }

  static PetKind petKindFromString(String petKindString) {
    return _petKindMap.keys.firstWhere((k) => _petKindMap[k] == petKindString,
        orElse: () => PetKind.OTHER);
  }

  static Color petStatusToColor(PetStatus status) {
    if (status == PetStatus.OPENED) {
      return Colors.green;
    } else if (status == PetStatus.RESERVED) {
      return Colors.yellow;
    } else {
      return Colors.red;
    }
  }
}
