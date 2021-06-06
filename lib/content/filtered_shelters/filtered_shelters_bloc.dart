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
                  (sheltersCubit.state as ListSheltersSuccessState).pets,
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
      final filteredShelters = _mapSheltersToFilteredShelters(
        (sheltersCubit.state as ListSheltersSuccessState).shelters,
        event.searchFilter,
      );
      final fileteredPets = _mapPetsToFilteredPets(
          (sheltersCubit.state as ListSheltersSuccessState).pets,
          filteredShelters);

      yield FilteredSheltersLoadSuccessState(
        filteredShelters,
        fileteredPets,
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
    final filteredShelters = _mapSheltersToFilteredShelters(
      (sheltersCubit.state as ListSheltersSuccessState).shelters,
      searchFilter,
    );
    final fileteredPets = _mapPetsToFilteredPets(
        (sheltersCubit.state as ListSheltersSuccessState).pets,
        filteredShelters);
    yield FilteredSheltersLoadSuccessState(
      filteredShelters,
      fileteredPets,
      (sheltersCubit.state as ListSheltersSuccessState).avatarsKeyUrl,
      searchFilter,
    );
  }

  List<Shelter> _mapSheltersToFilteredShelters(
      List<Shelter> shelters, String searchFilter) {
    return searchFilter.isEmpty
        ? shelters
        : shelters
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

  List<Pet> _mapPetsToFilteredPets(
      List<Pet> pets, List<Shelter> filteredShelters) {
    var filteredPets = <Pet>[];
    filteredShelters.map((shelter) {
      filteredPets
          .addAll(pets.where((pet) => pet.shelterID == shelter.id).toList());
    });
    return filteredPets;
  }

  @override
  Future<void> close() {
    sheltersSubscription.cancel();
    return super.close();
  }
}
