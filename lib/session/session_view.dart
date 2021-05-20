import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zoo_home/session/session_cubit.dart';

class SessionView extends StatelessWidget {
  final String email;

  SessionView({Key key, this.email}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Hello $email'),
            TextButton(
              child: Text('sign out'),
              onPressed: () => BlocProvider.of<SessionCubit>(context).signOut(),
            )
          ],
        ),
      ),
    );
  }
}
