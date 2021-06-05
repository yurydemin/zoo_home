import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zoo_home/content/filtered_shelters/filtered_shelters_event.dart';
import 'package:zoo_home/content/filtered_shelters/filtered_shelters_state.dart';
import 'package:zoo_home/content/shelters/shelters_cubit.dart';
import 'package:zoo_home/content/shelters/shelters_state.dart';
import 'package:zoo_home/models/ModelProvider.dart';

class FilteredSheltersBloc
    extends Bloc<FilteredSheltersEvent, FilteredSheltersState> {
  final SheltersCubit sheltersCubit;
  StreamSubscription sheltersSubscription;

  FilteredSheltersBloc({@required this.sheltersCubit})
      : super(
          sheltersCubit.state is ListSheltersSuccessState
              ? FilteredSheltersLoadSuccessState(
                  (sheltersCubit.state as ListSheltersSuccessState).shelters,
                  (sheltersCubit.state as ListSheltersSuccessState)
                      .avatarsKeyUrl,
                  '')
              : FilteredSheltersLoadInProgressState(),
        ) {
    sheltersSubscription = sheltersCubit.stream.listen((state) {
      if (state is ListSheltersSuccessState) {
        add(SheltersUpdated(
            (sheltersCubit.state as ListSheltersSuccessState).shelters));
      }
    });
  }

  @override
  Stream<FilteredSheltersState> mapEventToState(
      FilteredSheltersEvent event) async* {
    if (event is FilterUpdated) {
      yield* _mapFilterUpdateToState(event);
    } else if (event is SheltersUpdated) {
      yield* _mapSheltersUpdateToState(event);
    }
  }

  Stream<FilteredSheltersState> _mapFilterUpdateToState(
      FilterUpdated event) async* {
    if (sheltersCubit.state is ListSheltersSuccessState) {
      yield FilteredSheltersLoadSuccessState(
        _mapMoviesToFilteredMovies(
          (sheltersCubit.state as ListSheltersSuccessState).shelters,
          event.searchFilter,
        ),
        (sheltersCubit.state as ListSheltersSuccessState).avatarsKeyUrl,
        event.searchFilter,
      );
    }
  }

  Stream<FilteredSheltersState> _mapSheltersUpdateToState(
      SheltersUpdated event) async* {
    final searchFilter = state is FilteredSheltersLoadSuccessState
        ? (state as FilteredSheltersLoadSuccessState).searchFilter
        : '';
    yield FilteredSheltersLoadSuccessState(
      _mapMoviesToFilteredMovies(
        (sheltersCubit.state as ListSheltersSuccessState).shelters,
        searchFilter,
      ),
      (sheltersCubit.state as ListSheltersSuccessState).avatarsKeyUrl,
      searchFilter,
    );
  }

  List<Shelter> _mapMoviesToFilteredMovies(
      List<Shelter> shelters, String searchFilter) {
    return shelters
        .where((shelter) =>
            (shelter.title != null &&
                shelter.title
                    .toLowerCase()
                    .contains(searchFilter.toLowerCase())) ||
            (shelter.location != null &&
                shelter.location
                    .toLowerCase()
                    .contains(searchFilter.toLowerCase())))
        .toList();
  }

  @override
  Future<void> close() {
    sheltersSubscription.cancel();
    return super.close();
  }
}
