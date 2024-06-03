part of 'posts_bloc.dart';

@immutable
sealed class PostsState {}

final class PostsInitial extends PostsState {}

final class PostsLoading extends PostsState {}

final class PostsLoaded extends PostsState {
  final PostModelResponse posts;

  PostsLoaded(this.posts);
}

final class PostsLoadError extends PostsState {
  final String message;

  PostsLoadError(this.message);
}

final class PostAdded extends PostsState {
  final String message;

  PostAdded(this.message);
}

final class PostAddError extends PostsState {
  final String message;

  PostAddError(this.message);
}

final class PostAdding extends PostsState {}
