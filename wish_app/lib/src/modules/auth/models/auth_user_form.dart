class AuthUserForm {
  String? login;
  String? email;
  String? password;

  AuthUserForm({
    this.login,
    this.email,
    this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      "login": login,
      "email": email,
    };
  }
}
