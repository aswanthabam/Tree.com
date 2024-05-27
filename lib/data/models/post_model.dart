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
      imageUrl: json['image_url'],
      time: DateTime.parse(json['time']),
    );
  }
}
