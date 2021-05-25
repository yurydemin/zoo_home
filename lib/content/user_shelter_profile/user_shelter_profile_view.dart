import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:zoo_home/auth/form_submission_status.dart';
import 'package:zoo_home/content/content_cubit.dart';
import 'package:zoo_home/models/UserShelter.dart';
import 'package:zoo_home/content/user_shelter_profile/user_shelter_profile_bloc.dart';
import 'package:zoo_home/content/user_shelter_profile/user_shelter_profile_carousel.dart';
import 'package:zoo_home/content/user_shelter_profile/user_shelter_profile_event.dart';
import 'package:zoo_home/content/user_shelter_profile/user_shelter_profile_state.dart';
import 'package:zoo_home/content/user_shelters/user_shelter_repository.dart';
import 'package:zoo_home/repositories/storage_repository.dart';
import 'package:zoo_home/session/session_cubit.dart';

class UserShelterProfileView extends StatelessWidget {
  final UserShelter selectedUser;

  UserShelterProfileView({Key key, @required this.selectedUser})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final sessionCubit = context.read<SessionCubit>();
    return BlocProvider(
      create: (context) => UserShelterProfileBloc(
        userShelterRepo: context.read<UserShelterRepository>(),
        storageRepo: context.read<StorageRepository>(),
        user: selectedUser,
        isCurrentUser: sessionCubit.currentUser != null &&
            sessionCubit.currentUser.id == selectedUser.id,
      ),
      child: BlocListener<UserShelterProfileBloc, UserShelterProfileState>(
        listener: (context, state) {
          if (state.avatarImageSourceActionSheetIsVisible) {
            _showImageSourceActionSheet(context);
          }

          final formStatus = state.formStatus;
          if (formStatus is SubmissionFailed) {
            _showSnackBar(context, formStatus.exception.toString());
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
      child: BlocBuilder<UserShelterProfileBloc, UserShelterProfileState>(
          builder: (context, state) {
        return AppBar(
          title: Text('Зоодом'),
          centerTitle: true,
          actions: [
            if (state.isCurrentUser)
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
    return BlocBuilder<UserShelterProfileBloc, UserShelterProfileState>(
        builder: (context, state) {
      return SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 20),
              _avatar(),
              if (state.isCurrentUser) _changeAvatarButton(),
              SizedBox(height: 10),
              _titleTile(),
              _locationTile(),
              _emailTile(),
              _descriptionTile(),
              if (state.isCurrentUser) _addImagesButton(),
              if (state.imageUrls.isNotEmpty) _galleryCarousel(),
              if (state.isCurrentUser) _saveProfileChangesButton(),
              SizedBox(height: 10),
            ],
          ),
        ),
      );
    });
  }

  Widget _avatar() {
    return BlocBuilder<UserShelterProfileBloc, UserShelterProfileState>(
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
                ),
              ),
      );
    });
  }

  Widget _changeAvatarButton() {
    return BlocBuilder<UserShelterProfileBloc, UserShelterProfileState>(
        builder: (context, state) {
      return TextButton(
        onPressed: () =>
            context.read<UserShelterProfileBloc>().add(ChangeAvatarRequest()),
        child: Text('Изменить аватар'),
      );
    });
  }

  Widget _locationTile() {
    return BlocBuilder<UserShelterProfileBloc, UserShelterProfileState>(
        builder: (context, state) {
      return ListTile(
        tileColor: Colors.white,
        leading: Icon(Icons.location_city),
        title: TextFormField(
          initialValue: state.location,
          decoration: InputDecoration.collapsed(
              hintText: state.isCurrentUser ? 'Укажите город' : 'Город'),
          maxLines: null,
          readOnly: !state.isCurrentUser,
          toolbarOptions: ToolbarOptions(
            copy: state.isCurrentUser,
            cut: state.isCurrentUser,
            paste: state.isCurrentUser,
            selectAll: state.isCurrentUser,
          ),
          onChanged: (value) => context
              .read<UserShelterProfileBloc>()
              .add(UserShelterProfileLocationChanged(location: value)),
        ),
      );
    });
  }

  Widget _emailTile() {
    return BlocBuilder<UserShelterProfileBloc, UserShelterProfileState>(
        builder: (context, state) {
      return ListTile(
        tileColor: Colors.white,
        leading: Icon(Icons.mail),
        title: SelectableText(state.email),
      );
    });
  }

  Widget _titleTile() {
    return BlocBuilder<UserShelterProfileBloc, UserShelterProfileState>(
        builder: (context, state) {
      return ListTile(
        tileColor: Colors.white,
        leading: Icon(Icons.title),
        title: TextFormField(
          initialValue: state.title,
          decoration: InputDecoration.collapsed(
              hintText: state.isCurrentUser
                  ? 'Добавьте название своего зоодома'
                  : 'Название зоодома'),
          maxLines: null,
          readOnly: !state.isCurrentUser,
          toolbarOptions: ToolbarOptions(
            copy: state.isCurrentUser,
            cut: state.isCurrentUser,
            paste: state.isCurrentUser,
            selectAll: state.isCurrentUser,
          ),
          onChanged: (value) => context
              .read<UserShelterProfileBloc>()
              .add(UserShelterProfileTitleChanged(title: value)),
        ),
      );
    });
  }

  Widget _descriptionTile() {
    return BlocBuilder<UserShelterProfileBloc, UserShelterProfileState>(
        builder: (context, state) {
      return ListTile(
        tileColor: Colors.white,
        leading: Icon(Icons.edit),
        title: TextFormField(
          initialValue: state.description,
          decoration: InputDecoration.collapsed(
              hintText: state.isCurrentUser
                  ? 'Добавьте описание своего зоодома'
                  : 'Описание зоодома'),
          maxLines: null,
          readOnly: !state.isCurrentUser,
          toolbarOptions: ToolbarOptions(
            copy: state.isCurrentUser,
            cut: state.isCurrentUser,
            paste: state.isCurrentUser,
            selectAll: state.isCurrentUser,
          ),
          onChanged: (value) => context
              .read<UserShelterProfileBloc>()
              .add(UserShelterProfileDescriptionChanged(description: value)),
        ),
      );
    });
  }

  Widget _addImagesButton() {
    return BlocBuilder<UserShelterProfileBloc, UserShelterProfileState>(
        builder: (context, state) {
      return ListTile(
        tileColor: Colors.white,
        leading: Icon(Icons.photo_album),
        title: Text('Галерея'),
        trailing: GestureDetector(
          onTap: () => context
              .read<UserShelterProfileBloc>()
              .add(OpenMultiImagePicker(imageSource: ImageSource.gallery)),
          child: Icon(Icons.add_a_photo),
        ),
      );
    });
  }

  Widget _galleryCarousel() {
    return BlocBuilder<UserShelterProfileBloc, UserShelterProfileState>(
        builder: (context, state) {
      return UserShelterProfileCarousel(images: state.imageUrls);
    });
  }

  Widget _saveProfileChangesButton() {
    return BlocBuilder<UserShelterProfileBloc, UserShelterProfileState>(
        builder: (context, state) {
      return (state.formStatus is FormSubmitting)
          ? CircularProgressIndicator()
          : ElevatedButton(
              onPressed: () => context
                  .read<UserShelterProfileBloc>()
                  .add(SaveUserShelterProfileChanges()),
              child: Text('Сохранить изменения'),
            );
    });
  }

  void _showImageSourceActionSheet(BuildContext context) {
    Function(ImageSource) selectImageSource = (imageSource) {
      context
          .read<UserShelterProfileBloc>()
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
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
