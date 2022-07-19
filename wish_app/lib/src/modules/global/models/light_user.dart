class LightUser {
  late String id;
  late String login;
  late String? imageUrl;
  late String? userColor;

  LightUser({
    required this.id,
    required this.login,
    required this.imageUrl,
    required this.userColor,
  });

  LightUser.fromMap(Map<String, dynamic> data) {
    id = data["id"];
    login = data["login"];
    imageUrl = data["imageUrl"];
    userColor = data["userColor"];
  }
}
