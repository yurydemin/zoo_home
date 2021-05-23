import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zoo_home/content/content_cubit.dart';
import 'package:zoo_home/content/content_view.dart';
import 'package:zoo_home/models/UserShelter.dart';
import 'package:zoo_home/profile/user_shelter_profile_view.dart';

class ContentNavigator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ContentCubit, UserShelter>(builder: ((context, user) {
      return Navigator(
        pages: [
          MaterialPage(child: ContentView()),
          if (user != null)
            MaterialPage(
                child: UserShelterProfileView(
              selectedUser: user,
            ))
        ],
        onPopPage: (route, result) {
          BlocProvider.of<ContentCubit>(context).popToMain();
          return route.didPop(result);
        },
      );
    }));
  }
}
