import 'package:tree_com/data/models/user_model.dart';

class NearbyTree {
  final String treeId;
  final String title;
  final String? description;
  final double latitude;
  final double longitude;
  final String imgUrl;
  final UserInfoShort addedBy;
  double distance = 0;

  NearbyTree({
    required this.treeId,
    required this.title,
    this.description,
    required this.latitude,
    required this.longitude,
    required this.imgUrl,
    required this.addedBy,
  });

  factory NearbyTree.fromJson(Map<String, dynamic> json) {
    return NearbyTree(
      treeId: json['tree_id'],
      title: json['title'],
      description: json['description'],
      latitude: json['location'][0],
      longitude: json['location'][1],
      imgUrl: json['img_url'],
      addedBy: UserInfoShort(
        userId: json['added_by']['user_id'],
        name: json['added_by']['name'],
      ),
    );
  }
}

final class TreeInfo {
  final String title;
  final String? description;
  final String imageUrl;
  final String treeId;
  final int visitCount;
  final int streakCount;
  final DateTime lastVisited;
  final DateTime firstVisited;

  TreeInfo({
    required this.title,
    this.description,
    required this.imageUrl,
    required this.treeId,
    required this.visitCount,
    required this.streakCount,
    required this.lastVisited,
    required this.firstVisited,
  });

  factory TreeInfo.fromJson(Map<String, dynamic> json) {
    return TreeInfo(
      title: json['title'],
      // description: json['description'],
      imageUrl: json['image_url'],
      treeId: json['tree_id'],
      visitCount: json['visit_count'],
      streakCount: json['streak_count'],
      lastVisited: DateTime.parse(json['last_visited']),
      firstVisited: DateTime.parse(json['first_visited']),
    );
  }
}
