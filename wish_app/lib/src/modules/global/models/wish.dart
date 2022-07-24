import '../utils/generate_wish_image_path.dart';
import 'wish_user.dart';

class Wish {
  late int id;
  late String title;
  late String? description;
  late String? link;
  late String? imageUrl;
  late DateTime createdAt;
  late WishUser createdBy;
  late bool isFavorite;

  bool get hasImage => imageUrl != null ? true : false;

  String? get imagePath {
    if (hasImage) {
      final imagePath = generateWishImagePath(
        imageUrl!,
        id.toString(),
      );
      return imagePath;
    }
    return null;
  }

  Wish({
    required this.id,
    required this.title,
    this.description,
    this.link,
    this.imageUrl,
    required this.createdAt,
    required this.createdBy,
    this.isFavorite = false,
  });

  @override
  String toString() {
    return 'Wish: ${toJson()}';
  }

  Wish.fromJson(
    Map<String, dynamic> data,
    String? currentUserId, {
    bool isFavorite = false,
  }) {
    id = data["id"];
    title = data["title"];
    description = data["description"];
    link = data["link"];
    imageUrl = data["imageUrl"];
    createdAt = DateTime.parse(data["createdAt"] as String);
    createdBy = WishUser(
      id: data["createdBy"]["id"],
      login: data["createdBy"]["login"],
      imageUrl: data["createdBy"]["userImageUrl"],
      userColor: data["createdBy"]["userColor"],
      isCurrentUser: data["createdBy"]["id"] == currentUserId,
    );
    this.isFavorite = data["isFavorite"] ?? isFavorite;
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "title": title,
      "description": description,
      "link": link,
      "imageUrl": imageUrl,
      "createdAt": createdAt,
      "createdBy": {
        "id": createdBy.id,
        "login": createdBy.login,
        "imageUrl": createdBy.imageUrl,
        "userColor": createdBy.userColor,
        "isCurrentUser": createdBy.isCurrentUser,
      },
      "isFavorite": isFavorite,
    };
  }
}
