class LightWish {
  late int id;
  late String title;
  late String? imageUrl;
  late String? userColor;

  LightWish({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.userColor,
  });

  LightWish.fromMap(Map<String, dynamic> data) {
    id = data["id"];
    title = data["title"];
    imageUrl = data["imageUrl"];
    userColor = data["userColor"];
  }
}
