class SupabaseException implements Exception {
  String? msg;

  SupabaseException([this.msg]);

  @override
  String toString() => msg ?? 'SupabaseException';
}
