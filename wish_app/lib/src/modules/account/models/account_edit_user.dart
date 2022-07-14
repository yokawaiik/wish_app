class AccountEditUser {
  late String id;

  // late String previousName;
  // String? name;

  late String previousLogin;
  String? login;

  String? password;
  String? repeatPassword;

  String? imageUrl;
  String? imagePath;
  String? userColor;

  // bool get isNameChanged => previousName != name;
  bool get isLoginChanged => login == null ? false : previousLogin != login;

  bool get isUserInfoChanged => isLoginChanged == true;

  bool get isPasswordsEqual => password == repeatPassword;

  bool get hasImage => imageUrl != null;

  AccountEditUser({
    required this.id,
    // required this.previousName,
    // this.name,
    required this.previousLogin,
    this.login,
    this.password,
    this.repeatPassword,
    this.imageUrl,
  });

  AccountEditUser.fromMap(Map<String, dynamic> data) {
    id = data['id'];
    // previousName = data[''];
    previousLogin = data['login'];
    imageUrl = data['imageUrl'];
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "login": login ?? previousLogin,
      "imageUrl": imageUrl,
    };
  }

  // void update() {

  // }
}
