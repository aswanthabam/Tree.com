import 'dart:io';

import 'package:either_dart/either.dart';
import 'package:tree_com/core/utils/api.dart';
import 'package:tree_com/data/models/tree_model.dart';

class TreesDataSource {
  final API api;

  const TreesDataSource(this.api);

  Future<Either<String, String>> addTree(String title, String? description,
      File image, double latitude, double longitude) async {
    final response = await api.postImage('trees/add', image, {
      'title': title,
      'description': description,
      'location': "($latitude,$longitude)"
    });
    print(response);
    if (response.hasError) {
      return Left(response.message);
    }
    return Right(response.message);
  }

  Future<Either<List<NearbyTree>, String>> getNearbyTrees(
      double latitude, double longitude) async {
    final response = await api
        .post('trees/nearby-trees', {'location': "($latitude,$longitude)"});
    if (response.hasError) {
      return Right(response.message);
    }
    final trees = response.data['trees']
        .map<NearbyTree>((tree) => NearbyTree.fromJson(tree))
        .toList();
    return Left(trees);
  }

  Future<Either<String, String>> visitTree(
      File image, String treeId, String? content) async {
    final response = await api.postImage('trees/visit', image, {
      'content': content,
      'tree_id': treeId,
    });
    if (response.hasError) {
      return Right(response.message);
    }
    return Left(response.message);
  }
}
