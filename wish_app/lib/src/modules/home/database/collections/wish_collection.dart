import 'package:isar/isar.dart';
import '../constants/database_constants.dart' as database_constants;

part 'wish_collection.g.dart';

@Collection()
class WishCollection {
  final Id key = Isar.autoIncrement;

  @Index(
    name: database_constants.idIndexName,
    type: IndexType.value,
    unique: true,
  )
  late final int id;
  late String title;
  late String? imageUrl;
  late String? userColor;

  WishCollection({
    required this.id,
    required this.title,
    this.imageUrl,
    this.userColor,
  });
}
