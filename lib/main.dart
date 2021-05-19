import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zoo_home/auth/auth_repository.dart';
import 'package:zoo_home/auth/login/login_view.dart';

void main() {
  runApp(ZooHomeApp());
}

class ZooHomeApp extends StatelessWidget {
  const ZooHomeApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: RepositoryProvider(
        create: (context) => AuthRepository(),
        child: LoginView(),
      ),
    );
  }
}
