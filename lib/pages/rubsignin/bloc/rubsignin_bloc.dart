import 'package:bloc/bloc.dart';
import 'package:campus_app/core/authentication/authentication_repository.dart';
import 'package:campus_app/core/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

part 'rubsignin_event.dart';
part 'rubsignin_state.dart';

class RUBSignInBloc extends Bloc<RUBSignInEvent, RUBSignInState> {
  final AuthenticationRepository authenticationRepository;

  RUBSignInBloc({required this.authenticationRepository})
      : super(
          RUBSignInState(
            failureOrSuccessOption: none(),
            isSubmitting: false,
            showValidationMessages: false,
          ),
        ) {
    on<RUBSignInWithUsernameAndPassword>((event, emit) async {
      if (event.loginId == null || event.password == null) {
        emit(
          state.copyWith(isSubmitting: false, showValidationMessages: true),
        );
      } else {
        emit(
          state.copyWith(isSubmitting: true, showValidationMessages: false),
        );

        final failureOrSuccess =
            await authenticationRepository.signInWithRUBLoginID(
          loginID: event.loginId!,
          password: event.password!,
        );

        emit(
          state.copyWith(
            isSubmitting: false,
            failureOrSuccessOption: optionOf(failureOrSuccess),
          ),
        );
      }
    });

    on<RUBSignInWithTOTP>((event, emit) async {
      if (event.totp == null) {
        emit(state.copyWith(isSubmitting: false, showValidationMessages: true));
      } else {
        emit(state.copyWith(isSubmitting: true, showValidationMessages: false));

        final failureOrSuccess =
            await authenticationRepository.signInWith2FA(totp: event.totp!);

        emit(
          state.copyWith(
            isSubmitting: false,
            failureOrSuccessOption: optionOf(failureOrSuccess),
          ),
        );
      }
    });
  }
}
