import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zoo_home/auth/auth_cubit.dart';
import 'package:zoo_home/auth/auth_navigator.dart';
import 'package:zoo_home/session/session_cubit.dart';
import 'package:zoo_home/session/session_state.dart';
import 'package:zoo_home/session/session_view.dart';
import 'package:zoo_home/views/loading_view.dart';

class AppNavigator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SessionCubit, SessionState>(builder: (context, state) {
      return Navigator(
        pages: [
          // Show loading screen
          if (state is UnknownSessionState) MaterialPage(child: LoadingView()),

          // Show auth flow
          if (state is Unauthenticated)
            MaterialPage(
              child: BlocProvider(
                create: (context) =>
                    AuthCubit(sessionCubit: context.read<SessionCubit>()),
                child: AuthNavigator(),
              ),
            ),

          // Show session flow
          if (state is Authenticated)
            MaterialPage(
                child: SessionView(
              email: state.userShelter.email,
            ))
        ],
        onPopPage: (route, result) => route.didPop(result),
      );
    });
  }
}
