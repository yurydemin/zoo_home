abstract class UserShelterPetsEvent {}

class UserShelterPetsUpdatedEvent extends UserShelterPetsEvent {
  final String userShelterId;

  UserShelterPetsUpdatedEvent(this.userShelterId);
}
