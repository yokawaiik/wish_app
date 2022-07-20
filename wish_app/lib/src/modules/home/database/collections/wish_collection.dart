import 'package:isar/isar.dart';

part 'wish_collection.g.dart';

@Collection()
class WishCollection {
  final Id key = Isar.autoIncrement;

  @Index(name: "id", type: IndexType.value, unique: true)
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
