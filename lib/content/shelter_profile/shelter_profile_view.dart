import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mailto/mailto.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zoo_home/auth/form_submission_status.dart';
import 'package:zoo_home/content/content_cubit.dart';
import 'package:zoo_home/content/shelter_profile/shelter_profile_bloc.dart';
import 'package:zoo_home/content/shelter_profile/shelter_profile_event.dart';
import 'package:zoo_home/content/shelter_profile/shelter_profile_state.dart';
import 'package:zoo_home/repositories/shelters_repository.dart';
import 'package:zoo_home/models/ModelProvider.dart';
import 'package:zoo_home/repositories/storage_repository.dart';
import 'package:zoo_home/widgets/profile_carousel.dart';

class ShelterProfileView extends StatelessWidget {
  final Shelter selectedShelter;

  ShelterProfileView({Key key, @required this.selectedShelter})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ShelterProfileBloc(
          sheltersRepo: context.read<SheltersRepository>(),
          storageRepo: context.read<StorageRepository>(),
          shelter: selectedShelter,
          isCurrentShelter:
              selectedShelter.id == context.read<ContentCubit>().userShelterID),
      child: BlocListener<ShelterProfileBloc, ShelterProfileState>(
        listener: (context, state) {
          if (state.avatarImageSourceActionSheetIsVisible) {
            _showImageSourceActionSheet(context);
          }

          final formStatus = state.formStatus;
          if (formStatus is SubmissionFailed) {
            _showSnackBar(context, formStatus.exception.toString());
          } else if (formStatus is SubmissionSuccess) {
            _showSnackBar(context, 'Информация обновлена');
          }
        },
        child: Scaffold(
          backgroundColor: Color(0xFFF2F2F7),
          appBar: _appBar(),
          body: _profilePage(),
        ),
      ),
    );
  }

  Widget _appBar() {
    final appBarHeight = AppBar().preferredSize.height;
    return PreferredSize(
      preferredSize: Size.fromHeight(appBarHeight),
      child: BlocBuilder<ShelterProfileBloc, ShelterProfileState>(
          builder: (context, state) {
        return AppBar(
          title: Text(state.title),
          centerTitle: true,
          actions: [
            if (state.isCurrentShelter)
              IconButton(
                icon: Icon(Icons.logout),
                onPressed: () => context.read<ContentCubit>().signOut(),
              ),
          ],
        );
      }),
    );
  }

  Widget _profilePage() {
    return BlocBuilder<ShelterProfileBloc, ShelterProfileState>(
        builder: (context, state) {
      return SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 20),
              _avatar(),
              if (state.isCurrentShelter) _changeAvatarButton(),
              SizedBox(height: 10),
              _titleTile(),
              _locationTile(),
              _emailTile(),
              _descriptionTile(),
              if (state.isCurrentShelter) _addImagesButton(),
              if (state.imageUrls.isNotEmpty) _galleryCarousel(),
              state.isCurrentShelter
                  ? _saveProfileChangesButton()
                  : _mailToTextButton(),
              SizedBox(height: 10),
            ],
          ),
        ),
      );
    });
  }

  Widget _avatar() {
    return BlocBuilder<ShelterProfileBloc, ShelterProfileState>(
        builder: (context, state) {
      return Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.blue,
        ),
        width: 100,
        height: 100,
        child: state.avatarUrl == null
            ? Icon(
                Icons.person,
                size: 50,
              )
            : ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: CachedNetworkImage(
                  imageUrl: state.avatarUrl,
                  fit: BoxFit.cover,
                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                      Center(
                    child: CircularProgressIndicator(
                        value: downloadProgress.progress),
                  ),
                  errorWidget: (context, url, error) =>
                      Center(child: Icon(Icons.error)),
                ),
              ),
      );
    });
  }

  Widget _changeAvatarButton() {
    return BlocBuilder<ShelterProfileBloc, ShelterProfileState>(
        builder: (context, state) {
      return TextButton(
        onPressed: () =>
            context.read<ShelterProfileBloc>().add(ChangeAvatarRequest()),
        child: Text('Изменить аватар'),
      );
    });
  }

  Widget _locationTile() {
    return BlocBuilder<ShelterProfileBloc, ShelterProfileState>(
        builder: (context, state) {
      return ListTile(
        tileColor: Colors.white,
        leading: Icon(Icons.location_city),
        subtitle: Text('местоположение'),
        title: TextFormField(
          initialValue: state.location,
          decoration: InputDecoration.collapsed(
              hintText: state.isCurrentShelter ? 'Укажите город' : 'Город'),
          maxLines: null,
          readOnly: !state.isCurrentShelter,
          toolbarOptions: ToolbarOptions(
            copy: state.isCurrentShelter,
            cut: state.isCurrentShelter,
            paste: state.isCurrentShelter,
            selectAll: state.isCurrentShelter,
          ),
          onChanged: (value) => context
              .read<ShelterProfileBloc>()
              .add(ShelterProfileLocationChanged(location: value)),
        ),
      );
    });
  }

  Widget _emailTile() {
    return BlocBuilder<ShelterProfileBloc, ShelterProfileState>(
        builder: (context, state) {
      return ListTile(
        tileColor: Colors.white,
        leading: Icon(Icons.mail),
        subtitle: Text('адрес электронной почты'),
        title: SelectableText(state.email),
      );
    });
  }

  Widget _titleTile() {
    return BlocBuilder<ShelterProfileBloc, ShelterProfileState>(
        builder: (context, state) {
      return ListTile(
        tileColor: Colors.white,
        leading: Icon(Icons.title),
        subtitle: Text('название'),
        title: TextFormField(
          initialValue: state.title,
          decoration: InputDecoration.collapsed(
              hintText: state.isCurrentShelter
                  ? 'Добавьте название своего зоодома'
                  : 'Название зоодома'),
          maxLines: null,
          readOnly: !state.isCurrentShelter,
          toolbarOptions: ToolbarOptions(
            copy: state.isCurrentShelter,
            cut: state.isCurrentShelter,
            paste: state.isCurrentShelter,
            selectAll: state.isCurrentShelter,
          ),
          onChanged: (value) => context
              .read<ShelterProfileBloc>()
              .add(ShelterProfileTitleChanged(title: value)),
        ),
      );
    });
  }

  Widget _descriptionTile() {
    return BlocBuilder<ShelterProfileBloc, ShelterProfileState>(
        builder: (context, state) {
      return ListTile(
        tileColor: Colors.white,
        leading: Icon(Icons.edit),
        subtitle: Text('описание'),
        title: TextFormField(
          initialValue: state.description,
          decoration: InputDecoration.collapsed(
              hintText: state.isCurrentShelter
                  ? 'Добавьте описание своего зоодома'
                  : 'Описание зоодома'),
          maxLines: null,
          readOnly: !state.isCurrentShelter,
          toolbarOptions: ToolbarOptions(
            copy: state.isCurrentShelter,
            cut: state.isCurrentShelter,
            paste: state.isCurrentShelter,
            selectAll: state.isCurrentShelter,
          ),
          onChanged: (value) => context
              .read<ShelterProfileBloc>()
              .add(ShelterProfileDescriptionChanged(description: value)),
        ),
      );
    });
  }

  Widget _addImagesButton() {
    return BlocBuilder<ShelterProfileBloc, ShelterProfileState>(
        builder: (context, state) {
      return ListTile(
        tileColor: Colors.white,
        leading: Icon(Icons.photo_album),
        subtitle: Text('нажмите, чтобы добавить фото'),
        title: Text('Галерея'),
        onTap: () => context
            .read<ShelterProfileBloc>()
            .add(OpenMultiImagePicker(imageSource: ImageSource.gallery)),
      );
    });
  }

  Widget _galleryCarousel() {
    return BlocBuilder<ShelterProfileBloc, ShelterProfileState>(
        builder: (context, state) {
      return ProfileCarousel(
        imageKeys: state.shelter.imageKeys,
        imageUrls: state.imageUrls,
        onRemoveImage: (String imageKey, String imageUrl) {
          context.read<ShelterProfileBloc>().add(ShelterProfileRemoveImage(
              imageKey: imageKey, imageUrl: imageUrl));
        },
        isRemovable: state.isCurrentShelter,
      );
    });
  }

  Widget _saveProfileChangesButton() {
    return BlocBuilder<ShelterProfileBloc, ShelterProfileState>(
        builder: (context, state) {
      return (state.formStatus is FormSubmitting)
          ? CircularProgressIndicator()
          : ElevatedButton(
              onPressed: () => context
                  .read<ShelterProfileBloc>()
                  .add(SaveShelterProfileChanges()),
              child: Text('Сохранить изменения'),
            );
    });
  }

  Widget _mailToTextButton() {
    return BlocBuilder<ShelterProfileBloc, ShelterProfileState>(
        builder: (context, state) {
      final targetEmail = state.shelter.contact;
      final targetUserShelterName = state.shelter.title;
      return TextButton(
        onPressed: () async {
          final url = Mailto(
            to: [targetEmail],
            subject: 'Новый вопрос к зоодому "$targetUserShelterName"',
            body: 'Здравствуйте, у меня вопрос',
          ).toString();
          if (await canLaunch(url)) {
            await launch(url);
          } else {
            _showSnackBar(context,
                'Не удалось открыть почтовый клиент для отправки письма по ссылке $url');
          }
        },
        child: Text('Связаться с нами'),
      );
    });
  }

  void _showImageSourceActionSheet(BuildContext context) {
    Function(ImageSource) selectImageSource = (imageSource) {
      context
          .read<ShelterProfileBloc>()
          .add(OpenImagePicker(imageSource: imageSource));
    };

    if (Platform.isIOS) {
      showCupertinoModalPopup(
        context: context,
        builder: (context) => CupertinoActionSheet(
          actions: [
            CupertinoActionSheetAction(
              child: Text('Камера'),
              onPressed: () {
                Navigator.pop(context);
                selectImageSource(ImageSource.camera);
              },
            ),
            CupertinoActionSheetAction(
              child: Text('Галерея'),
              onPressed: () {
                Navigator.pop(context);
                selectImageSource(ImageSource.gallery);
              },
            )
          ],
        ),
      );
    } else {
      showModalBottomSheet(
        context: context,
        builder: (context) => Wrap(children: [
          ListTile(
            leading: Icon(Icons.camera_alt),
            title: Text('Камера'),
            onTap: () {
              Navigator.pop(context);
              selectImageSource(ImageSource.camera);
            },
          ),
          ListTile(
            leading: Icon(Icons.photo_album),
            title: Text('Галерея'),
            onTap: () {
              Navigator.pop(context);
              selectImageSource(ImageSource.gallery);
            },
          ),
        ]),
      );
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(
      content: Text(message),
      duration: const Duration(milliseconds: 1000),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
