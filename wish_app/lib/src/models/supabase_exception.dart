enum KindOfException {
  unknown,
  notFound,
  auth,
}

class SupabaseException implements Exception {
  String title;
  String msg;

  KindOfException kindOfException;

  SupabaseException(this.title, this.msg,
      [this.kindOfException = KindOfException.unknown]);

  @override
  String toString() => "$title: $msg";
}
