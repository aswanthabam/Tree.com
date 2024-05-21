part of 'trees_bloc.dart';

@immutable
sealed class TreesState {}

final class TreesInitial extends TreesState {}


final class TreesAddLoading extends TreesState {}

final class TreesAddSuccess extends TreesState {
  final String message;

  TreesAddSuccess(this.message);
}

final class TreesAddFailure extends TreesState {
  final String message;

  TreesAddFailure(this.message);
}

final class TreesGetNearbyLoading extends TreesState {}

final class TreesGetNearbySuccess extends TreesState {
  final List<NearbyTree> trees;

  TreesGetNearbySuccess(this.trees);
}

final class TreesGetNearbyFailure extends TreesState {
  final String message;

  TreesGetNearbyFailure(this.message);
}