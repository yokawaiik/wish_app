import 'package:isar/isar.dart';
import '../constants/database_constants.dart' as database_constants;

part 'user_collection.g.dart';

@Collection()
class UserCollection {
  final Id key = Isar.autoIncrement;

  @Index(
    name: database_constants.idIndexName,
    type: IndexType.value,
    unique: true,
  )
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
