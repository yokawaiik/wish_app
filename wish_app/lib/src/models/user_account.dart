class UserAccount {
  late String id;
  late String login;
  late String? imageUrl;
  late String? userColor;
  late bool isCurrentUser;

  UserAccount({
    required this.id,
    required this.login,
    this.imageUrl,
    this.userColor,
    this.isCurrentUser = false,
  });

  UserAccount.fromJson(Map<String, dynamic> data, String? currentUser) {
    id = data["id"];
    login = data["login"];
    imageUrl = data["imageUrl"];
    userColor = data["userColor"];
    isCurrentUser = id == currentUser;
  }
}
