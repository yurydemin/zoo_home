import 'package:flutter_bloc/flutter_bloc.dart';

enum AppTab { pets, userShelters }

class TabCubit extends Cubit<AppTab> {
  TabCubit() : super(AppTab.pets);

  void updateTab({
    AppTab tab,
  }) =>
      emit(tab);
}
