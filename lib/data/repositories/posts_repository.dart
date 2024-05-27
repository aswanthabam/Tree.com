import 'dart:io';

import 'package:either_dart/either.dart';
import 'package:tree_com/data/datasources/posts_data_source.dart';
import 'package:tree_com/data/models/post_model.dart';

class PostsRepository {
  final PostsDataSource dataSource;

  const PostsRepository(this.dataSource);

  Future<Either<String, String>> addPost(File? image, String? content) async {
    return await dataSource.addPost(image, content);
  }

  Future<Either<List<PostModel>, String>> getPosts(String? username) async {
    return await dataSource.getPosts(username);
  }
}
