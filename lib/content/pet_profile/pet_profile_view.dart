import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mailto/mailto.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zoo_home/auth/form_submission_status.dart';
import 'package:zoo_home/content/pet_profile/pet_profile_bloc.dart';
import 'package:zoo_home/content/pet_profile/pet_profile_event.dart';
import 'package:zoo_home/content/pet_profile/pet_profile_state.dart';
import 'package:zoo_home/repositories/pets_repository.dart';
import 'package:zoo_home/helpers/pet_visual_helper.dart';
import 'package:zoo_home/models/ModelProvider.dart';
import 'package:zoo_home/repositories/storage_repository.dart';
import 'package:zoo_home/widgets/profile_carousel.dart';

class PetProfileView extends StatefulWidget {
  final Pet selectedPet;
  final String contact;

  PetProfileView({Key key, @required this.selectedPet, @required this.contact})
      : super(key: key);
  @override
  _PetProfileViewState createState() => _PetProfileViewState();
}

class _PetProfileViewState extends State<PetProfileView> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PetProfileBloc(
        petsRepo: context.read<PetsRepository>(),
        storageRepo: context.read<StorageRepository>(),
        pet: widget.selectedPet,
        isCurrentPet:
            true, //TODO selectedPet.shelterID == context.read<ContentCubit>().loggedInUserShelterID
      ),
      child: BlocListener<PetProfileBloc, PetProfileState>(
        listener: (context, state) {
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
      child: BlocBuilder<PetProfileBloc, PetProfileState>(
          builder: (context, state) {
        return AppBar(
          title: Text(state.title),
          centerTitle: true,
          // TODO Remove pet
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
              if (!state.isCurrentPet && state.status == PetStatus.OPENED)
                _mailToTextButton(),
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
      return ProfileCarousel(
        imageKeys: state.pet.imageKeys,
        imageUrls: state.imageUrls,
        onRemoveImage: (String imageKey, String imageUrl) {
          context.read<PetProfileBloc>().add(
              PetProfileRemoveImage(imageKey: imageKey, imageUrl: imageUrl));
        },
        isRemovable: state.isCurrentPet,
      );
    });
  }

  Widget _galleryPlaceHolder() {
    return Image.asset(
      widget.selectedPet.kind == PetKind.CAT
          ? 'assets/images/cat_placeholder.jpg'
          : widget.selectedPet.kind == PetKind.DOG
              ? 'assets/images/dog_placeholder.jpg'
              : 'assets/images/other_placeholder.jpg',
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
        subtitle: Text('статус карточки животного'),
        title: state.isCurrentPet
            ? DropdownButtonFormField<String>(
                value: PetVisualHelper.petStatusToString(state.status),
                items: PetStatus.values
                    .map(
                      (label) => DropdownMenuItem(
                        child: Text(PetVisualHelper.petStatusToString(label)),
                        value: PetVisualHelper.petStatusToString(label),
                      ),
                    )
                    .toList(),
                onChanged: (value) => setState(() {
                  context.read<PetProfileBloc>().add(PetProfileStatusChanged(
                      status: PetVisualHelper.petStatusFromString(value)));
                }),
              )
            : Text(PetVisualHelper.petStatusToString(state.status)),
      );
    });
  }

  Widget _kindTile() {
    return BlocBuilder<PetProfileBloc, PetProfileState>(
        builder: (context, state) {
      return ListTile(
        tileColor: Colors.white,
        leading: Icon(Icons.pets),
        subtitle: Text('категория'),
        title: state.isCurrentPet
            ? DropdownButtonFormField<String>(
                value: PetVisualHelper.petKindToString(state.kind),
                items: PetKind.values
                    .map(
                      (label) => DropdownMenuItem(
                        child: Text(PetVisualHelper.petKindToString(label)),
                        value: PetVisualHelper.petKindToString(label),
                      ),
                    )
                    .toList(),
                onChanged: (value) => setState(() {
                  context.read<PetProfileBloc>().add(PetProfileKindChanged(
                      kind: PetVisualHelper.petKindFromString(value)));
                }),
              )
            : Text(PetVisualHelper.petKindToString(state.kind)),
      );
    });
  }

  Widget _titleTile() {
    return BlocBuilder<PetProfileBloc, PetProfileState>(
        builder: (context, state) {
      return ListTile(
        tileColor: Colors.white,
        leading: Icon(Icons.title),
        subtitle: Text('имя животного'),
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
        subtitle: Text('информация о животном'),
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

  Widget _mailToTextButton() {
    return BlocBuilder<PetProfileBloc, PetProfileState>(
        builder: (context, state) {
      final targetEmail = widget.contact;
      final petCardTitle = state.pet.title;
      return TextButton(
        onPressed: () async {
          final url = Mailto(
            to: [targetEmail],
            subject: 'Новая заявка на "$petCardTitle"',
            body: 'Здравствуйте, меня интересует животное "$petCardTitle".',
          ).toString();
          if (await canLaunch(url)) {
            await launch(url);
          } else {
            _showSnackBar(context,
                'Не удалось открыть почтовый клиент для отправки письма по ссылке $url');
          }
        },
        child: Text('Оставить заявку'),
      );
    });
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
