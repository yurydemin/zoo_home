import 'package:zoo_home/auth/form_submission_status.dart';
import 'package:zoo_home/helpers/validation_helper.dart';

class LoginState {
  final String email;
  bool get isValidEmail => ValidationHelper.validateEmail(email);

  final String password;
  bool get isValidPassword => password.length >= 8;

  final FormSubmissionStatus formStatus;

  LoginState({
    this.email = '',
    this.password = '',
    this.formStatus = const InitialFormStatus(),
  });

  LoginState copyWith({
    String email,
    String password,
    FormSubmissionStatus formStatus,
  }) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      formStatus: formStatus ?? this.formStatus,
    );
  }
}
