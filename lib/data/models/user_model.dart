import 'package:tree_com/data/models/tree_model.dart';

class TokenData {
  final String accessToken;
  final String email;

  TokenData({required this.accessToken, required this.email});
}

class UserInfoShort {
  final String name;
  final String userId;

  UserInfoShort({required this.userId, required this.name});
}

class UserProfile {
  final String name;
  final String username;
  final String? bio;
  final List<TreeInfo> trees;
  final int streak;
  final List posts;

  UserProfile({
    required this.name,
    required this.username,
    this.bio,
    required this.trees,
    required this.streak,
    required this.posts,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      name: json['name'],
      username: json['username'],
      bio: json['bio'],
      streak: json['streak'],
      posts: json['posts'],
      trees: json['trees'].map<TreeInfo>((tree) => TreeInfo.fromJson(tree)).toList(),
    );
  }
}
