class Wish {
  late int id;
  late String title;
  late String? description;
  late String? link;
  late String? imageUrl;
  late DateTime createdAt;
  late String createdBy;
  late bool? isCurrentUser;

  bool get hasImage => imageUrl != null ? true : false;

  Wish({
    required this.id,
    required this.title,
    this.description,
    this.link,
    this.imageUrl,
    required this.createdAt,
    required this.createdBy,
    this.isCurrentUser = false,
  });

  Wish.fromJson(Map<String, dynamic> data, String? currentUserId) {

    id = data["id"];
    title = data["title"];
    description = data["description"];
    link = data["link"];
    imageUrl = data["imageUrl"];
    createdAt = DateTime.parse(data["createdAt"] as String);
    createdBy = data["createdBy"];
    isCurrentUser = data["createdBy"] == currentUserId;
  }
}
