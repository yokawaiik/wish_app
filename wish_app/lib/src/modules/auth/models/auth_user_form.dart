class AuthUserForm {
  String? login;
  String? email;
  String? password;
  String? userColor;

  AuthUserForm({
    this.login,
    this.email,
    this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      "login": login,
      "email": email,
      "userColor": userColor,
    };
  }
}
