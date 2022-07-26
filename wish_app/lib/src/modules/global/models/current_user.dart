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
    this.email,
    required this.phone,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "appMetadata": appMetadata,
      "userMetadata": userMetadata,
      "aud": aud,
      "email": email,
      "phone": phone,
      "createdAt": createdAt,
    };
  }
}
