import 'package:isar/isar.dart';

part 'user_collection.g.dart';

@Collection()
class UserCollection {
  final Id key = Isar.autoIncrement;

  @Index(name: "id", type: IndexType.value, unique: true)
  late final String id;
  late String login;
  late String? imageUrl;
  late String? userColor;

  UserCollection({
    required this.id,
    required this.login,
    this.imageUrl,
    this.userColor,
  });
}
