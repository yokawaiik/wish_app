enum KindOfException { unknown, notFound, auth, jwtExpired }

class SupabaseException implements Exception {
  String title;
  String msg;

  KindOfException kindOfException;

  SupabaseException(this.title, this.msg,
      [this.kindOfException = KindOfException.unknown]);

  @override
  String toString() => "$title: $msg, with kind of exception $kindOfException";
}
