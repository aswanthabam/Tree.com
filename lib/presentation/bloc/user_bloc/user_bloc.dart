import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:tree_com/data/models/user_model.dart';
import 'package:tree_com/data/repositories/user_repository.dart';

part 'user_event.dart';

part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository _repository;

  UserBloc({required UserRepository repository})
      : _repository = repository,
        super(UserInitial()) {
    on<RegisterUser>((event, emit) async {
      emit(UserRegistering());
      await _repository
          .register(event.email, event.name, event.password)
          .then((result) {
        result.fold(
          (tokenData) => emit(UserRegistered(tokenData)),
          (message) => emit(UserRegistrationFailed(message)),
        );
      });
    });

    on<LoginUser>((event, emit) async {
      emit(UserLogging());
      await _repository.login(event.email, event.password).then((result) {
        print(result);
        result.fold(
          (tokenData) => emit(UserLoggedIn(tokenData)),
          (message) => emit(UserLoggedInFailed(message)),
        );
      });
    });
  }
}
