import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_absolute_path/flutter_absolute_path.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_image_picker2/multi_image_picker2.dart';
import 'package:zoo_home/auth/form_submission_status.dart';
import 'package:zoo_home/content/shelter_profile/shelter_profile_event.dart';
import 'package:zoo_home/content/shelter_profile/shelter_profile_state.dart';
import 'package:zoo_home/content/shelters/shelters_repository.dart';
import 'package:zoo_home/models/ModelProvider.dart';
import 'package:zoo_home/repositories/storage_repository.dart';
import 'package:zoo_home/services/image_url_cache.dart';

class ShelterProfileBloc
    extends Bloc<ShelterProfileEvent, ShelterProfileState> {
  final SheltersRepository sheltersRepo;
  final StorageRepository storageRepo;
  final _imagePicker = ImagePicker();

  ShelterProfileBloc({
    @required this.sheltersRepo,
    @required this.storageRepo,
    @required Shelter shelter,
    @required bool isCurrentShelter,
  }) : super(ShelterProfileState(
            shelter: shelter, isCurrentShelter: isCurrentShelter)) {
    ImageUrlCache.instance
        .getUrl(shelter.avatarKey)
        .then((url) => add(ProvideAvatarImagePath(avatarUrl: url)));
    Future.wait(shelter.imageKeys.map((imageKey) async {
      return await ImageUrlCache.instance.getUrl(imageKey);
    }).toList())
        .then((urls) => add(ProvideProfileImagesPaths(imageUrls: urls)));
  }

  @override
  Stream<ShelterProfileState> mapEventToState(
      ShelterProfileEvent event) async* {
    if (event is ChangeAvatarRequest) {
      yield state.copyWith(avatarImageSourceActionSheetIsVisible: true);
    } else if (event is OpenImagePicker) {
      yield state.copyWith(avatarImageSourceActionSheetIsVisible: false);

      final pickedImage =
          await _imagePicker.getImage(source: event.imageSource);
      if (pickedImage == null) return;

      final imageKey = await storageRepo.uploadFile(
          File(pickedImage.path), state.shelter.id);
      final updatedShelter = state.shelter.copyWith(avatarKey: imageKey);

      final results = await Future.wait([
        sheltersRepo.updateShelter(updatedShelter),
        storageRepo.getUrlForFile(imageKey),
      ]);

      yield state.copyWith(shelter: updatedShelter, avatarUrl: results.last);
    } else if (event is ProvideAvatarImagePath) {
      yield state.copyWith(avatarUrl: event.avatarUrl);
    } else if (event is OpenMultiImagePicker) {
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
        return await storageRepo.uploadFile(File(imagePath), state.shelter.id);
      }).toList());
      // get images urls
      final newImageUrls = await Future.wait(newImageKeys.map((imageKey) async {
        return await storageRepo.getUrlForFile(imageKey);
      }).toList());
      // combine keys and urls with existing
      final imageKeys = [...state.shelter.imageKeys, ...newImageKeys];
      final imageUrls = [...state.imageUrls, ...newImageUrls];

      // update user and state
      final updatedShelter = state.shelter.copyWith(imageKeys: imageKeys);
      await sheltersRepo.updateShelter(updatedShelter);

      yield state.copyWith(shelter: updatedShelter, imageUrls: imageUrls);
    } else if (event is ProvideProfileImagesPaths) {
      yield state.copyWith(imageUrls: event.imageUrls);
    } else if (event is ShelterProfileLocationChanged) {
      yield state.copyWith(location: event.location);
    } else if (event is ShelterProfileTitleChanged) {
      yield state.copyWith(title: event.title);
    } else if (event is ShelterProfileDescriptionChanged) {
      yield state.copyWith(description: event.description);
    } else if (event is ShelterProfileRemoveImage) {
      final updatedImageKeys = state.shelter.imageKeys
          .where((item) => item != event.imageKey)
          .toList();
      final updatedShelter =
          state.shelter.copyWith(imageKeys: updatedImageKeys);
      await sheltersRepo.updateShelter(updatedShelter);

      final updatedImageUrls =
          state.imageUrls.where((item) => item != event.imageUrl).toList();
      yield state.copyWith(
          shelter: updatedShelter, imageUrls: updatedImageUrls);
    } else if (event is SaveShelterProfileChanges) {
      yield state.copyWith(formStatus: FormSubmitting());

      final updatedShelter = state.shelter.copyWith(
        location: state.location,
        title: state.title,
        description: state.description,
      );

      try {
        await sheltersRepo.updateShelter(updatedShelter);
        yield state.copyWith(
            shelter: updatedShelter, formStatus: SubmissionSuccess());
      } catch (e) {
        yield state.copyWith(formStatus: SubmissionFailed(e));
      }
    }
  }
}
