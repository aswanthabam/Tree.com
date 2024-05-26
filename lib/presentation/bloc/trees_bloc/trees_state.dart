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

final class TreesVisitLoading extends TreesState {}

final class TreesVisitSuccess extends TreesState {
  final String message;

  TreesVisitSuccess(this.message);
}

final class TreesVisitFailure extends TreesState {
  final String message;

  TreesVisitFailure(this.message);
}

final class TreesVisitedPicsLoading extends TreesState {}

final class TreesVisitedPicsSuccess extends TreesState {
  final List<TreeVisit> visits;

  TreesVisitedPicsSuccess(this.visits);
}

final class TreesVisitedPicsFailure extends TreesState {
  final String message;

  TreesVisitedPicsFailure(this.message);
}
