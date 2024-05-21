part of 'trees_bloc.dart';

@immutable
sealed class TreesEvent {}

final class AddTreeEvent extends TreesEvent {
  final File image;
  final String title;
  final String? description;
  final double latitude;
  final double longitude;

  AddTreeEvent({
    required this.image,
    required this.title,
    this.description,
    required this.latitude,
    required this.longitude,
  });
}

final class GetNearbyTreesEvent extends TreesEvent {
  final double latitude;
  final double longitude;

  GetNearbyTreesEvent({
    required this.latitude,
    required this.longitude,
  });
}
