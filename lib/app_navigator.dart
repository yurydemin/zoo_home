import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zoo_home/auth/auth_cubit.dart';
import 'package:zoo_home/auth/auth_navigator.dart';
import 'package:zoo_home/content/content_cubit.dart';
import 'package:zoo_home/content/content_navigator.dart';
import 'package:zoo_home/session/session_cubit.dart';
import 'package:zoo_home/session/session_state.dart';
import 'package:zoo_home/views/loading_view.dart';

class AppNavigator extends StatelessWidget {
  final _navigatorKey = GlobalKey<NavigatorState>();
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SessionCubit, SessionState>(builder: (context, state) {
      return WillPopScope(
        onWillPop: () async {
          _navigatorKey.currentState.maybePop();
          return false;
        },
        child: Navigator(
          key: _navigatorKey,
          pages: [
            // loading screen
            if (state is UnknownSessionState)
              MaterialPage(child: LoadingView()),

            // auth flow
            if (state is UnauthenticatedState)
              MaterialPage(
                child: BlocProvider(
                  create: (context) =>
                      AuthCubit(sessionCubit: context.read<SessionCubit>()),
                  child: AuthNavigator(),
                ),
              ),

            // content flow
            if (state is AuthenticatedAsGuestState ||
                state is AuthenticatedAsUserState)
              MaterialPage(
                child: BlocProvider(
                  create: (context) =>
                      ContentCubit(sessionCubit: context.read<SessionCubit>()),
                  child: ContentNavigator(),
                ),
              ),
          ],
          onPopPage: (route, result) => route.didPop(result),
        ),
      );
    });
  }
}
