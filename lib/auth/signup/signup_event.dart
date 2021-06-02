abstract class SignUpEvent {}

class SignUpEmailChanged extends SignUpEvent {
  final String email;

  SignUpEmailChanged({this.email});
}

class SignUpPasswordChanged extends SignUpEvent {
  final String password;

  SignUpPasswordChanged({this.password});
}

class SignUpSubmitted extends SignUpEvent {}

class SignUpResetSubmition extends SignUpEvent {}
