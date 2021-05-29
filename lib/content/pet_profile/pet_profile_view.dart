import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:zoo_home/auth/form_submission_status.dart';
import 'package:zoo_home/content/pet_profile/pet_profile_bloc.dart';
import 'package:zoo_home/content/pet_profile/pet_profile_event.dart';
import 'package:zoo_home/content/pet_profile/pet_profile_state.dart';
import 'package:zoo_home/content/pets/pets_repository.dart';
import 'package:zoo_home/helpers/pet_visual_helper.dart';
import 'package:zoo_home/models/ModelProvider.dart';
import 'package:zoo_home/repositories/storage_repository.dart';
import 'package:zoo_home/session/session_cubit.dart';
import 'package:zoo_home/widgets/profile_carousel.dart';

class PetProfileView extends StatefulWidget {
  final Pet selectedPet;

  PetProfileView({Key key, @required this.selectedPet}) : super(key: key);
  @override
  _PetProfileViewState createState() => _PetProfileViewState();
}

class _PetProfileViewState extends State<PetProfileView> {
  @override
  Widget build(BuildContext context) {
    final sessionCubit = context.read<SessionCubit>();
    return BlocProvider(
      create: (context) => PetProfileBloc(
        petsRepo: context.read<PetsRepository>(),
        storageRepo: context.read<StorageRepository>(),
        pet: widget.selectedPet,
        isCurrentPet: sessionCubit.currentUser != null &&
            sessionCubit.currentUser.id == widget.selectedPet.userShelterId,
      ),
      child: BlocListener<PetProfileBloc, PetProfileState>(
        listener: (context, state) {
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
      child: BlocBuilder<PetProfileBloc, PetProfileState>(
          builder: (context, state) {
        return AppBar(
          title: Text(state.title),
          centerTitle: true,
          // actions: [
          //   if (state.isCurrentPet)
          //     IconButton(
          //       icon: Icon(Icons.logout),
          //       onPressed: () => context.read<PetsCubit>().deletePet(),
          //     ),
          // ],
        );
      }),
    );
  }

  Widget _profilePage() {
    return BlocBuilder<PetProfileBloc, PetProfileState>(
        builder: (context, state) {
      return SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 10),
              state.imageUrls.isEmpty
                  ? _galleryPlaceHolder()
                  : _galleryCarousel(),
              if (state.isCurrentPet) _addPetPhotosButton(),
              SizedBox(height: 10),
              _statusTile(),
              _kindTile(),
              _titleTile(),
              _descriptionTile(),
              if (state.isCurrentPet) _saveProfileChangesButton(),
              SizedBox(height: 10),
            ],
          ),
        ),
      );
    });
  }

  Widget _addPetPhotosButton() {
    return BlocBuilder<PetProfileBloc, PetProfileState>(
        builder: (context, state) {
      return TextButton(
        onPressed: () => context
            .read<PetProfileBloc>()
            .add(OpenMultiImagePicker(imageSource: ImageSource.gallery)),
        child: Text('Добавить фото животного'),
      );
    });
  }

  Widget _galleryCarousel() {
    return BlocBuilder<PetProfileBloc, PetProfileState>(
        builder: (context, state) {
      return ProfileCarousel(images: state.imageUrls);
    });
  }

  Widget _galleryPlaceHolder() {
    return Image.asset(
      'assets/images/other_placeholder.jpg',
      height: 250,
    );
  }

  Widget _statusTile() {
    return BlocBuilder<PetProfileBloc, PetProfileState>(
        builder: (context, state) {
      return ListTile(
        tileColor: Colors.white,
        leading: Icon(Icons.more_vert_rounded),
        trailing: Icon(
          Icons.circle,
          color: PetVisualHelper.petStatusToColor(state.status),
        ),
        title: state.isCurrentPet
            ? DropdownButtonFormField<String>(
                value: EnumToString.convertToString(state.status),
                items: PetStatus.values
                    .map(
                      (label) => DropdownMenuItem(
                        child: Text(EnumToString.convertToString(label)),
                        value: EnumToString.convertToString(label),
                      ),
                    )
                    .toList(),
                onChanged: (value) => setState(() {
                  context.read<PetProfileBloc>().add(PetProfileStatusChanged(
                      status:
                          EnumToString.fromString(PetStatus.values, value)));
                }),
              )
            : Text(EnumToString.convertToString(state.status)),
      );
    });
  }

  Widget _kindTile() {
    return BlocBuilder<PetProfileBloc, PetProfileState>(
        builder: (context, state) {
      return ListTile(
        tileColor: Colors.white,
        leading: Icon(Icons.pets),
        title: state.isCurrentPet
            ? DropdownButtonFormField<String>(
                value: EnumToString.convertToString(state.kind),
                items: PetKind.values
                    .map(
                      (label) => DropdownMenuItem(
                        child: Text(EnumToString.convertToString(label)),
                        value: EnumToString.convertToString(label),
                      ),
                    )
                    .toList(),
                onChanged: (value) => setState(() {
                  context.read<PetProfileBloc>().add(PetProfileKindChanged(
                      kind: EnumToString.fromString(PetKind.values, value)));
                }),
              )
            : Text(EnumToString.convertToString(state.kind)),
      );
    });
  }

  Widget _titleTile() {
    return BlocBuilder<PetProfileBloc, PetProfileState>(
        builder: (context, state) {
      return ListTile(
        tileColor: Colors.white,
        leading: Icon(Icons.title),
        title: TextFormField(
          initialValue: state.title,
          decoration: InputDecoration.collapsed(
              hintText: state.isCurrentPet
                  ? 'Укажите имя животного'
                  : 'Имя животного'),
          maxLines: null,
          readOnly: !state.isCurrentPet,
          toolbarOptions: ToolbarOptions(
            copy: state.isCurrentPet,
            cut: state.isCurrentPet,
            paste: state.isCurrentPet,
            selectAll: state.isCurrentPet,
          ),
          onChanged: (value) => context
              .read<PetProfileBloc>()
              .add(PetProfileTitleChanged(title: value)),
        ),
      );
    });
  }

  Widget _descriptionTile() {
    return BlocBuilder<PetProfileBloc, PetProfileState>(
        builder: (context, state) {
      return ListTile(
        tileColor: Colors.white,
        leading: Icon(Icons.edit),
        title: TextFormField(
          initialValue: state.description,
          decoration: InputDecoration.collapsed(
              hintText: state.isCurrentPet
                  ? 'Добавьте информацию о животном'
                  : 'Информация о животном'),
          maxLines: null,
          readOnly: !state.isCurrentPet,
          toolbarOptions: ToolbarOptions(
            copy: state.isCurrentPet,
            cut: state.isCurrentPet,
            paste: state.isCurrentPet,
            selectAll: state.isCurrentPet,
          ),
          onChanged: (value) => context
              .read<PetProfileBloc>()
              .add(PetProfileDescriptionChanged(description: value)),
        ),
      );
    });
  }

  Widget _saveProfileChangesButton() {
    return BlocBuilder<PetProfileBloc, PetProfileState>(
        builder: (context, state) {
      return (state.formStatus is FormSubmitting)
          ? CircularProgressIndicator()
          : ElevatedButton(
              onPressed: () =>
                  context.read<PetProfileBloc>().add(SavePetProfileChanges()),
              child: Text('Сохранить изменения'),
            );
    });
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
