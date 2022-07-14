// the model for field "created by" in Wish model
class WishUser {
  String id;
  String login;
  String? imageUrl;
  String? userColor;

  bool isCurrentUser;

  WishUser({
    required this.id,
    required this.login,
    this.imageUrl,
    this.userColor,
    this.isCurrentUser = false,
  });
}
