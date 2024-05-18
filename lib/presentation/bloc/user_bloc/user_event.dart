part of 'user_bloc.dart';

@immutable
sealed class UserEvent {}

final class RegisterUser extends UserEvent {
  final String email;
  final String name;
  final String password;

  RegisterUser(this.email, this.name, this.password);
}

final class LoginUser extends UserEvent {
  final String email;
  final String password;

  LoginUser({required this.email, required this.password});
}
