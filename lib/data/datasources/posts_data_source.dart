import 'dart:io';

import 'package:either_dart/either.dart';
import 'package:tree_com/core/utils/api.dart';
import 'package:tree_com/data/models/post_model.dart';

class PostsDataSource {
  final API api;

  const PostsDataSource(this.api);

  Future<Either<String, String>> addPost(File? image, String? content) async {
    final response = await api.postImage('post/new', image, {
      'content': content,
    });
    if (response.hasError) {
      return Left(response.message);
    }
    return Right(response.message);
  }

  Future<Either<List<PostModel>, String>> getPosts(String? username) async {
    final response = await api.get('posts');
    if (response.hasError) {
      return Right(response.message);
    }
    final posts = response.data['posts']
        .map<PostModel>((post) => PostModel.fromJson(post))
        .toList();
    return Left(posts);
  }
}
