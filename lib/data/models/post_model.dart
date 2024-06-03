final class PostModel {
  final String post_id;
  final String? content;
  final String? imageUrl;
  final DateTime time;

  PostModel({
    required this.post_id,
    this.content,
    this.imageUrl,
    required this.time,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      post_id: json['post_id'],
      content: json['content'],
      imageUrl: json['img_url'],
      time: DateTime.parse(json['time']),
    );
  }
}


final class PostModelResponse {
  final List<PostModel> posts;
  final int page;
  final bool has_next;

  PostModelResponse({
    required this.posts,
    required this.page,
    required this.has_next,
  });

  factory PostModelResponse.fromJson(Map<String, dynamic> json) {
    return PostModelResponse(
      posts: json['posts']
          .map<PostModel>((post) => PostModel.fromJson(post))
          .toList(),
      page: json['page'],
      has_next: json['has_next'],
    );
  }
}