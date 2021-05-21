import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zoo_home/profile/user_shelter_profile_bloc.dart';
import 'package:zoo_home/profile/user_shelter_profile_event.dart';
import 'package:zoo_home/profile/user_shelter_profile_state.dart';
import 'package:zoo_home/session/session_cubit.dart';

class UserShelterProfileView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final sessionCubit = context.read<SessionCubit>();
    return BlocProvider(
      create: (context) => UserShelterProfileBloc(
        user: sessionCubit.selectedUser ?? sessionCubit.currentUser,
        isCurrentUser: sessionCubit.isCurrentUserSelected,
      ),
      child: Scaffold(
        backgroundColor: Color(0xFFF2F2F7),
        appBar: _appBar(),
        body: _profilePage(),
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
          actions: [
            if (state.isCurrentUser)
              IconButton(
                icon: Icon(Icons.logout),
                onPressed: () {},
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
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 20),
                _avatar(),
                if (state.isCurrentUser) _changeAvatarButton(),
                SizedBox(height: 10),
                _titleTile(),
                SizedBox(height: 20),
                _locationTile(),
                _emailTile(),
                _descriptionTile(),
                if (state.isCurrentUser) _saveProfileChangesButton(),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _avatar() {
    return BlocBuilder<UserShelterProfileBloc, UserShelterProfileState>(
        builder: (context, state) {
      return CircleAvatar(
        radius: 50,
        child: Icon(Icons.person),
      );
    });
  }

  Widget _changeAvatarButton() {
    return BlocBuilder<UserShelterProfileBloc, UserShelterProfileState>(
        builder: (context, state) {
      return TextButton(
        onPressed: () {},
        child: Text('Change Avatar'),
      );
    });
  }

  Widget _locationTile() {
    return BlocBuilder<UserShelterProfileBloc, UserShelterProfileState>(
        builder: (context, state) {
      return ListTile(
        tileColor: Colors.white,
        leading: Icon(Icons.location_city),
        title: Text(state.location),
      );
    });
  }

  Widget _emailTile() {
    return BlocBuilder<UserShelterProfileBloc, UserShelterProfileState>(
        builder: (context, state) {
      return ListTile(
        tileColor: Colors.white,
        leading: Icon(Icons.mail),
        title: Text(state.email),
      );
    });
  }

  Widget _titleTile() {
    return BlocBuilder<UserShelterProfileBloc, UserShelterProfileState>(
        builder: (context, state) {
      return ListTile(
        tileColor: Colors.white,
        leading: Icon(Icons.title),
        title: Text(state.title),
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

  Widget _saveProfileChangesButton() {
    return BlocBuilder<UserShelterProfileBloc, UserShelterProfileState>(
        builder: (context, state) {
      return ElevatedButton(
        onPressed: () {},
        child: Text('Сохранить изменения'),
      );
    });
  }
}
