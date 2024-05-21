import 'dart:io';

import 'package:either_dart/either.dart';
import 'package:tree_com/data/datasources/trees_data_source.dart';
import 'package:tree_com/data/models/tree_model.dart';

class TreeRepository {
  final TreesDataSource dataSource;

  const TreeRepository(this.dataSource);

  Future<Either<String, String>> addTree(String title, String? description,
      File image, double latitude, double longitude) async {
    return await dataSource.addTree(
        title, description, image, latitude, longitude);
  }

  Future<Either<List<NearbyTree>, String>> getNearbyTrees(
      double latitude, double longitude) async {
    return await dataSource.getNearbyTrees(latitude, longitude);
  }
}
