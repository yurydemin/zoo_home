import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zoo_home/auth/auth_cubit.dart';
import 'package:zoo_home/auth/auth_repository.dart';
import 'package:zoo_home/auth/confirm/confirmation_event.dart';
import 'package:zoo_home/auth/confirm/confirmation_state.dart';
import 'package:zoo_home/auth/form_submission_status.dart';

class ConfirmationBloc extends Bloc<ConfirmationEvent, ConfirmationState> {
  final AuthRepository authRepo;
  final AuthCubit authCubit;

  ConfirmationBloc({
    this.authRepo,
    this.authCubit,
  }) : super(ConfirmationState());

  @override
  Stream<ConfirmationState> mapEventToState(ConfirmationEvent event) async* {
    // Confirmation code updated
    if (event is ConfirmationCodeChanged) {
      yield state.copyWith(code: event.code);

      // Form submitted
    } else if (event is ConfirmationSubmitted) {
      yield state.copyWith(formStatus: FormSubmitting());

      try {
        final userId = await authRepo.confirmSignUp(
          email: authCubit.credentials.email,
          confirmationCode: state.code,
        );
        print(userId);
        yield state.copyWith(formStatus: SubmissionSuccess());

        final credentials = authCubit.credentials;
        credentials.userShelterId = userId;
        print(credentials);
        authCubit.launchSession(credentials);
      } catch (e) {
        print(e);
        yield state.copyWith(formStatus: SubmissionFailed(e));
      }
    }
  }
}
