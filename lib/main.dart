import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zoo_home/app_navigator.dart';
import 'package:zoo_home/auth/auth_repository.dart';
import 'package:zoo_home/session/session_cubit.dart';

void main() {
  runApp(ZooHomeApp());
}

class ZooHomeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: RepositoryProvider(
        create: (context) => AuthRepository(),
        child: BlocProvider(
          create: (context) =>
              SessionCubit(authRepo: context.read<AuthRepository>()),
          child: AppNavigator(),
        ),
      ),
    );
  }
}
