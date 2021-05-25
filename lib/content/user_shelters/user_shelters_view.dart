import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zoo_home/content/content_cubit.dart';
import 'package:zoo_home/content/user_shelters/user_shelter_cubit.dart';
import 'package:zoo_home/content/user_shelters/user_shelter_state.dart';
import 'package:zoo_home/models/UserShelter.dart';
import 'package:zoo_home/widgets/user_shelter_card.dart';

class UserSheltersView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Зоодома'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.home),
            onPressed: () => context.read<ContentCubit>().showAuthOrProfile(),
          ),
        ],
      ),
      body: BlocBuilder<UserShelterCubit, UserShelterState>(
          builder: (context, state) {
        if (state is ListUserSheltersSuccess) {
          return state.userShelters.isEmpty
              ? _emptyUserSheltersView()
              : _userSheltersListView(state.userShelters, state.avatarsKeyUrl);
        } else if (state is ListUserSheltersFailure) {
          return _exceptionView(state.exception);
        } else {
          return Container(
            color: Colors.white,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      }),
    );
  }

  Widget _exceptionView(Exception exception) {
    return Center(child: Text(exception.toString()));
  }

  Widget _emptyUserSheltersView() {
    return Center(
      child: Text('Еще не создано ни одного зоодома'),
    );
  }

  Widget _userSheltersListView(
      List<UserShelter> userShelters, Map<String, String> avatarsKeyUrl) {
    return ListView.builder(
      itemCount: userShelters.length,
      itemBuilder: (BuildContext context, int index) {
        final userShelter = userShelters[index];
        return UserShelterCard(
            onTap: () => context
                .read<ContentCubit>()
                .showProfile(selectedUser: userShelter),
            userShelter: userShelter,
            avatarUrl: avatarsKeyUrl.containsKey(userShelter.avatarKey)
                ? avatarsKeyUrl[userShelter.avatarKey]
                : null);
      },
    );
  }
}
