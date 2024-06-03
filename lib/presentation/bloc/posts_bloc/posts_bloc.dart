import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:tree_com/data/models/post_model.dart';
import 'package:tree_com/data/repositories/posts_repository.dart';

part 'posts_event.dart';

part 'posts_state.dart';

class PostsBloc extends Bloc<PostsEvent, PostsState> {
  final PostsRepository _repository;

  PostsBloc({required PostsRepository repository})
      : _repository = repository,
        super(PostsInitial()) {
    on<AddPostEvent>(_onAddPost);
    on<GetPostsEvent>(_onGetPosts);
  }

  Future<void> _onAddPost(AddPostEvent event, Emitter<PostsState> emit) async {
    emit(PostAdding());
    final response = await _repository.addPost(event.image, event.content);
    response.fold(
      (message) => emit(PostAddError(message)),
      (message) => emit(PostAdded(message)),
    );
  }

  Future<void> _onGetPosts(GetPostsEvent event, Emitter<PostsState> emit) async {
    emit(PostsLoading());
    final response = await _repository.getPosts(event.username);
    print(response);
    response.fold(
      (posts) => emit(PostsLoaded(posts)),
      (message) => emit(PostsLoadError(message)),
    );
  }
}
