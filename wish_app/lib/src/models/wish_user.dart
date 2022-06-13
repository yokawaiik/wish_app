class WishUser {
  String id;
  String login;
  String? imageUrl;

  String? userColor;

  WishUser({
    required this.id,
    required this.login,
    this.imageUrl,
    this.userColor,
  });
}
