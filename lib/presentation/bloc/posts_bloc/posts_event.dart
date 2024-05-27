part of 'posts_bloc.dart';

@immutable
sealed class PostsEvent {}


class AddPostEvent extends PostsEvent {
  final File?  image;
  final String? content;

  AddPostEvent(this.image, this.content);
}

class GetPostsEvent extends PostsEvent {
  final String? username;

  GetPostsEvent(this.username);
}