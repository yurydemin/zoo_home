import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_datastore/amplify_datastore.dart';
import 'package:amplify_flutter/amplify.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zoo_home/amplifyconfiguration.dart';
import 'package:zoo_home/app_navigator.dart';
import 'package:zoo_home/auth/auth_repository.dart';
import 'package:zoo_home/models/ModelProvider.dart';
import 'package:zoo_home/repositories/data_repository.dart';
import 'package:zoo_home/session/session_cubit.dart';
import 'package:zoo_home/views/loading_view.dart';

void main() {
  runApp(ZooHomeApp());
}

class ZooHomeApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ZooHomeAppState();
}

class _ZooHomeAppState extends State<ZooHomeApp> {
  bool _isAmplifyConfigured = false;

  @override
  void initState() {
    super.initState();
    _configureAmplify();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: _isAmplifyConfigured
            ? MultiRepositoryProvider(
                providers: [
                  RepositoryProvider(create: (context) => AuthRepository()),
                  RepositoryProvider(create: (context) => DataRepository())
                ],
                child: BlocProvider(
                  create: (context) => SessionCubit(
                    authRepo: context.read<AuthRepository>(),
                    dataRepo: context.read<DataRepository>(),
                  ),
                  child: AppNavigator(),
                ),
              )
            : LoadingView());
  }

  Future<void> _configureAmplify() async {
    try {
      await Amplify.addPlugins([
        AmplifyAuthCognito(),
        AmplifyDataStore(modelProvider: ModelProvider.instance),
        AmplifyAPI(),
      ]);

      await Amplify.configure(amplifyconfig);

      setState(() => _isAmplifyConfigured = true);
    } catch (e) {
      print(e);
    }
  }
}
