part of 'rubsignin_bloc.dart';

class RUBSignInState {
  final bool isSubmitting;
  final bool showValidationMessages;
  final Option<Either<Failure, Unit>> failureOrSuccessOption;

  RUBSignInState({
    required this.isSubmitting,
    required this.showValidationMessages,
    required this.failureOrSuccessOption,
  });

  RUBSignInState copyWith({
    bool? isSubmitting,
    bool? showValidationMessages,
    bool? totpRequested,
    Option<Either<Failure, Unit>>? failureOrSuccessOption,
  }) {
    return RUBSignInState(
      isSubmitting: isSubmitting ?? this.isSubmitting,
      showValidationMessages:
          showValidationMessages ?? this.showValidationMessages,
      failureOrSuccessOption:
          failureOrSuccessOption ?? this.failureOrSuccessOption,
    );
  }
}
