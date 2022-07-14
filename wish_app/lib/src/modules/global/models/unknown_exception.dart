class UnknownException implements Exception {
  String? title;
  String? msg;

  UnknownException([this.title, this.msg]);

  @override
  String toString() => "$title: $msg";
}
