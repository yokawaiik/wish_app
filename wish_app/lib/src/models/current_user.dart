class CurrentUser {
  String id;
  Map<String, dynamic> appMetadata;
  Map<String, dynamic> userMetadata;
  String aud;
  String? email;
  String? phone;
  String createdAt;

  CurrentUser({
    required this.id,
    required this.appMetadata,
    required this.userMetadata,
    required this.aud,
    required this.email,
    required this.phone,
    required this.createdAt,
  });
}
