class SupabaseException implements Exception {
  String title;
  String msg;

  SupabaseException(this.title, this.msg);

  @override
  String toString() => "$title: $msg";
}
