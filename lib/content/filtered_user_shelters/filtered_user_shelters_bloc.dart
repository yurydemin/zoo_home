import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zoo_home/content/filtered_user_shelters/filtered_user_shelters_event.dart';
import 'package:zoo_home/content/filtered_user_shelters/filtered_user_shelters_state.dart';
import 'package:zoo_home/content/user_shelters/user_shelters_cubit.dart';
import 'package:zoo_home/content/user_shelters/user_shelters_state.dart';
import 'package:zoo_home/models/ModelProvider.dart';

class FilteredUserSheltersBloc
    extends Bloc<FilteredUserSheltersEvent, FilteredUserSheltersState> {
  final UserSheltersCubit userSheltersCubit;
  StreamSubscription userSheltersSubscription;

  FilteredUserSheltersBloc({@required this.userSheltersCubit})
      : super(
          userSheltersCubit.state is ListUserSheltersSuccessState
              ? FilteredUserSheltersLoadSuccessState(
                  (userSheltersCubit.state as ListUserSheltersSuccessState)
                      .userShelters,
                  (userSheltersCubit.state as ListUserSheltersSuccessState)
                      .avatarsKeyUrl,
                  '')
              : FilteredUserSheltersLoadInProgressState(),
        ) {
    userSheltersSubscription = userSheltersCubit.stream.listen((state) {
      if (state is ListUserSheltersSuccessState) {
        add(UserSheltersUpdated(
            (userSheltersCubit.state as ListUserSheltersSuccessState)
                .userShelters));
      }
    });
  }

  @override
  Stream<FilteredUserSheltersState> mapEventToState(
      FilteredUserSheltersEvent event) async* {
    if (event is FilterUpdated) {
      yield* _mapFilterUpdateToState(event);
    } else if (event is UserSheltersUpdated) {
      yield* _mapUserSheltersUpdateToState(event);
    }
  }

  Stream<FilteredUserSheltersState> _mapFilterUpdateToState(
      FilterUpdated event) async* {
    if (userSheltersCubit.state is ListUserSheltersSuccessState) {
      yield FilteredUserSheltersLoadSuccessState(
        _mapMoviesToFilteredMovies(
          (userSheltersCubit.state as ListUserSheltersSuccessState)
              .userShelters,
          event.searchFilter,
        ),
        (userSheltersCubit.state as ListUserSheltersSuccessState).avatarsKeyUrl,
        event.searchFilter,
      );
    }
  }

  Stream<FilteredUserSheltersState> _mapUserSheltersUpdateToState(
      UserSheltersUpdated event) async* {
    final searchFilter = state is FilteredUserSheltersLoadSuccessState
        ? (state as FilteredUserSheltersLoadSuccessState).searchFilter
        : '';
    yield FilteredUserSheltersLoadSuccessState(
      _mapMoviesToFilteredMovies(
        (userSheltersCubit.state as ListUserSheltersSuccessState).userShelters,
        searchFilter,
      ),
      (userSheltersCubit.state as ListUserSheltersSuccessState).avatarsKeyUrl,
      searchFilter,
    );
  }

  List<UserShelter> _mapMoviesToFilteredMovies(
      List<UserShelter> userShelters, String searchFilter) {
    return userShelters
        .where((userShelter) =>
            userShelter.title
                .toLowerCase()
                .contains(searchFilter.toLowerCase()) ||
            userShelter.location
                .toLowerCase()
                .contains(searchFilter.toLowerCase()))
        .toList();
  }

  @override
  Future<void> close() {
    userSheltersSubscription.cancel();
    return super.close();
  }
}
