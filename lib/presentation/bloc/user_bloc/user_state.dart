part of 'user_bloc.dart';

@immutable
sealed class UserState {}

final class UserInitial extends UserState {}

final class UserRegistering extends UserState {}

final class UserLogging extends UserState {}

final class UserRegistered extends UserState {
  final TokenData tokenData;

  UserRegistered(this.tokenData);
}

final class UserRegistrationFailed extends UserState {
  final String message;

  UserRegistrationFailed(this.message);
}

final class UserLoggedIn extends UserState {
  final TokenData tokenData;

  UserLoggedIn(this.tokenData);
}

final class UserLoggedInFailed extends UserState {
  final String message;

  UserLoggedInFailed(this.message);
}

final class UserProfileLoaded extends UserState {
  final UserProfile userProfile;

  UserProfileLoaded(this.userProfile);
}

final class UserProfileLoadingFailed extends UserState {
  final String message;

  UserProfileLoadingFailed(this.message);
}

final class UserProfileLoading extends UserState {}