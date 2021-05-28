import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_absolute_path/flutter_absolute_path.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multi_image_picker2/multi_image_picker2.dart';
import 'package:zoo_home/content/pet_profile/pet_profile_event.dart';
import 'package:zoo_home/content/pet_profile/pet_profile_state.dart';
import 'package:zoo_home/content/pets/pets_repository.dart';
import 'package:zoo_home/models/Pet.dart';
import 'package:zoo_home/repositories/storage_repository.dart';
import 'package:zoo_home/services/image_url_cache.dart';

class PetProfileBloc extends Bloc<PetProfileEvent, PetProfileState> {
  final PetsRepository petsRepo;
  final StorageRepository storageRepo;

  PetProfileBloc({
    @required this.petsRepo,
    @required this.storageRepo,
    @required Pet pet,
    @required bool isCurrentPet,
  }) : super(PetProfileState(pet: pet, isCurrentPet: isCurrentPet)) {
    Future.wait(pet.images.map((imageKey) async {
      return await ImageUrlCache.instance.getUrl(imageKey);
    }).toList())
        .then((urls) => add(ProvideProfileImagesPaths(imageUrls: urls)));
  }

  @override
  Stream<PetProfileState> mapEventToState(PetProfileEvent event) async* {
    if (event is OpenMultiImagePicker) {
      // pick images from gallery
      List<Asset> pickedImages = <Asset>[];
      try {
        pickedImages = await MultiImagePicker.pickImages(
          maxImages: 8,
          enableCamera: false,
          cupertinoOptions: CupertinoOptions(
            takePhotoIcon: "chat",
            doneButtonTitle: "Fatto",
          ),
          materialOptions: MaterialOptions(
            actionBarColor: "#abcdef",
            actionBarTitle: "Галерея зоодома",
            allViewTitle: "Все изображения",
            useDetailsView: false,
            selectCircleStrokeColor: "#000000",
          ),
        );
      } on Exception catch (e) {
        print(e.toString());
      }
      if (pickedImages == null || pickedImages.isEmpty) return;

      // upload files and get keys
      final newImageKeys = await Future.wait(pickedImages.map((image) async {
        final imagePath =
            await FlutterAbsolutePath.getAbsolutePath(image.identifier);
        return await storageRepo.uploadFile(File(imagePath), state.pet.id);
      }).toList());
      // get images urls
      final newImageUrls = await Future.wait(newImageKeys.map((imageKey) async {
        return await storageRepo.getUrlForFile(imageKey);
      }).toList());
      // compare keys and urls with existing
      final imageKeys = [...state.pet.images, ...newImageKeys];
      final imageUrls = [...state.imageUrls, ...newImageUrls];

      // update pet and state
      final updatedPet = state.pet.copyWith(images: imageKeys);
      await petsRepo.updatePet(updatedPet);

      yield state.copyWith(pet: updatedPet, imageUrls: imageUrls);
    } else if (event is ProvideProfileImagesPaths) {
      yield state.copyWith(imageUrls: event.imageUrls);
    }
  }
}
