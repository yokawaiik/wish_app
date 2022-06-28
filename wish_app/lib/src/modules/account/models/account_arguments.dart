class AccountArguments {
  final String? tag; // user id

  AccountArguments([
    this.tag,
  ]);

  Map<String, dynamic> toMap() {
    return {
      "tag": tag,
    };
  }
}
