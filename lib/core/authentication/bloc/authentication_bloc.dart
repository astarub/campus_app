import 'package:bloc/bloc.dart';
import 'package:campus_app/core/authentication/authentication_repository.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final AuthenticationRepository authenticationRepository;

  AuthenticationBloc({required this.authenticationRepository})
      : super(AuthenticationInitial()) {
    on<SignOutEvent>((event, emit) async {
      await authenticationRepository.signOut();
      emit(AuthenticationTodoState());
    });

    on<AuthCheckRequestedEvent>((event, emit) async {
      if (await authenticationRepository.allreadyAuthenticated()) {
        emit(Authentication2FATodoState());
      } else {
        emit(AuthenticationTodoState());
      }
    });

    on<TOTPCheckRequestedEvent>((event, emit) async {
      if (await authenticationRepository.valid2FASession()) {
        emit(Authentication2FADoneState());
      } else {
        emit(Authentication2FATodoState());
      }
    });
  }
}
