class CurrentUser {
  String id;
  Map<String, dynamic> appMetadata;
  Map<String, dynamic> userMetadata;
  String aud;
  String? email;
  String? phone;
  String createdAt;

  // String login;

  CurrentUser({
    required this.id,
    required this.appMetadata,
    required this.userMetadata,
    required this.aud,
    this.email,
    required this.phone,
    required this.createdAt,
    //
    // required this.login,
  });
}
